//
//  GithubAPIService.swift
//  MoyaStubbableTests
//
//  Created by Xavier De Koninck on 18/12/2017.
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
    return .requestPlain
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
  
  var excludedStubKeys: [String] {
    return ["q"]
  }
}

private extension String {
  var URLEscapedString: String {
    return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
  }
}
