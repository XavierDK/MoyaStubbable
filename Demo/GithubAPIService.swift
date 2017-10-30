//
//  GithubAPIService.swift
//  Demo
//
//  Created by Xavier De Koninck on 25/10/2017.
//  Copyright © 2017 Xavier De Koninck. All rights reserved.
//

import Foundation
import Moya
import MoyaStubbable

enum GitHubAPI {
  
  case userProfile(String)
  case failableUserProfile(String)
}

extension GitHubAPI: StubbableTargetType {
  
  var task: Task {
    return .requestParameters(parameters: ["key1":"value1", "key2":"value2", "key3":"value3"], encoding: URLEncoding.default)
  }
  
  var headers: [String : String]? {
    return nil
  }
  
  var baseURL: URL { return URL(string: "https://api.github.com")! }
  
  var path: String {
    switch self {
    case .userProfile(let name):
      return "/users/\(name.URLEscapedString)"
    case .failableUserProfile:
      return "/users/." // There is no user with name ., so we will get 404 for our stub
    }
  }
  
  var method: Moya.Method {
    switch self {
    case .userProfile:
      return .get
    case .failableUserProfile:
      return .post
    }
  }
  
  public var excludedStubKeys: [String] {
    
    return ["key2"]
  }
}

private extension String {
  var URLEscapedString: String {
    return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
  }
}

