//
//  StubbableTargetType.swift
//  MoyaStubbable
//
//  Created by Xavier De Koninck on 25/10/2017.
//  Copyright © 2017 Xavier De Koninck. All rights reserved.
//

import Moya

fileprivate let stubsDirectoryKey = "StubsDirectoryPath"

enum NetworkPluginError: Error {
  
  case stubsDirectoryNotFound
  case nameGeneration
  case invalidURL
}

public protocol StubbableTargetType: TargetType {
  
  var excludedStubKeys: [String] { get }
}

public extension StubbableTargetType {
  
  public var sampleData: Data {
    
    return (try? read(name: generateName())) ?? Data()
  }
  
  func generateName() throws -> String {
    
    let url = path.replacingOccurrences(of: "/", with: ":").components(separatedBy: "?")[0]
    
    let parameters: String
    if case let .requestParameters(parameters: params, encoding: _) = task {
      var components: [String: Any] = params
      for (key, _) in components {
        if excludedStubKeys.contains(key) {
          components.removeValue(forKey: key)
        }
      }
      parameters = dictionaryToStub(components)
    }
    else {
      parameters = ""
    }
    
    if let selfString = "\(self)".components(separatedBy: "(").first {
      return "\(type(of: self))_\(selfString)_\(url)_\(parameters)"
    } else {
      return "\(type(of: self))_\(self)_\(url)_\(parameters)"
    }
  }
  
  func dictionaryToStub(_ dic: [String : Any]) -> String {
    return dic.sorted(by: { (arg0, arg1) -> Bool in
      let (key1, _) = arg0
      let (key2, _) = arg1
      return key1 < key2
    })
      .map({ (key, value) in
        return "\(key)=\(value)"
      })
      .joined(separator: "&")
  }
  
  func url(forName name: String) throws -> String {
    
    let bundle = Bundle.allBundles.filter({ $0.infoDictionary?[stubsDirectoryKey] != nil }).first
    guard let infoPlist = bundle?.infoDictionary,
      let stubsPath = infoPlist[stubsDirectoryKey] as? String
      else { throw NetworkPluginError.stubsDirectoryNotFound }
    
    return "\(stubsPath)\(name).json"
  }
  
  func read(name: String) throws -> Data {
    
    let urlStr = try url(forName: name)
    guard let url = URL(string: "file://" + urlStr) else { throw NetworkPluginError.invalidURL }
    let data = try Data(contentsOf: url)
    return data
  }
}
