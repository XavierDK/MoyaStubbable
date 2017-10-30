//
//  NetworkRecorderPlugin.swift
//  MoyaStubbable
//
//  Created by Xavier De Koninck on 25/10/2017.
//  Copyright © 2017 Xavier De Koninck. All rights reserved.
//

import Foundation
import Moya
import Result

public final class NetworkRecorderPlugin: PluginType {
  
  public init() {}
  
  public func didReceive(_ result: Result<Moya.Response, MoyaError>, target: TargetType) {
    
    switch result {
    case .failure:
      break
    case .success(let response):
      guard let t = target as? StubbableTargetType else { return }
      do {
        let url = try t.url(forName: t.generateName())
        let text = try response.mapString()
        try text.write(toFile: url, atomically: true, encoding: String.Encoding.utf8)
      }
      catch {
        print(error)
      }
    }
  }
}
