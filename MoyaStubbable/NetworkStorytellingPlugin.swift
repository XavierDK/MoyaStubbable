//
//  NetworkStoryReaderPlugin.swift
//  MoyaStubbable
//
//  Created by Xavier De Koninck on 26/10/2017.
//  Copyright © 2017 Xavier De Koninck. All rights reserved.
//

import Foundation
import Moya
import Result

public struct StubStory {
  
  public let success: Bool
  public let code: Int
  public let name: String
  
  public init(success: Bool, code: Int, name: String) {
    self.success = success
    self.code = code
    self.name = name
  }
}

public final class NetworkStorytellingPlugin: PluginType {
  
  let stubsStory: [StubStory]
  var currentIndex = 0
  
  public init(stubsStory: [StubStory]) {
    
    self.stubsStory = stubsStory
  }
  
  public func process(_ result: Result<Moya.Response, MoyaError>, target: TargetType) -> Result<Moya.Response, MoyaError> {
    
    let data: Data
    
    guard stubsStory.count > currentIndex else { return result }
    let stub = stubsStory[currentIndex]
    if let target = target as? StubbableTargetType {
      data = (try? target.read(name: stub.name)) ?? Data()
      currentIndex += 1
    }
    else {
      data = Data()
    }
    
    if stub.success {
      return .success(Moya.Response(statusCode: stub.code, data: data))
    }
    else {
      return .failure(.statusCode(Moya.Response(statusCode: stub.code, data: data)))
    }
  }
}
