//
//  DemoTests.swift
//  DemoTests
//
//  Created by Xavier De Koninck on 26/10/2017.
//  Copyright © 2017 Xavier De Koninck. All rights reserved.
//

import XCTest
import Moya
@testable import Demo
@testable import MoyaStubbable

class DemoTests: XCTestCase {
  
  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
  
   let provider = MoyaProvider<GitHubAPI>(plugins: [NetworkStoryReaderPlugin(stubsStory: ["GitHubAPI_failableUserProfile_:users:._key1=value1&key3=value3", "GitHubAPI_userProfile_:users:xavierdk_key1=value1&key3=value3"])])
  
  func testExample() {
    
   
    
    provider
      .request(.userProfile("xavierdk")) { result in
        let json = try? result.value?.mapJSON()
        print("Success results1: \(json)")
        self.expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: json, handler: nil)
        
    }
    provider
      .request(.userProfile("xavierdk")) { result in
        let json = try? result.value?.mapJSON()
        print("Success results2: \(json)")
        self.expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: json, handler: nil)
    }
    
    waitForExpectations(timeout: 5, handler: nil)
  }
  
  func testExample2() {

    let provider = MoyaProvider<GitHubAPI>(plugins: [NetworkStoryReaderPlugin(stubsStory: ["GitHubAPI_failableUserProfile_:users:._key1=value1&key3=value3", "GitHubAPI_userProfile_:users:xavierdk_key1=value1&key3=value3"])])

    provider
      .request(.userProfile("xavierdk")) { result in
        let json = try? result.value?.mapJSON()
        print("Success results3: \(json)")
        
        self.expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: json, handler: nil)
    }
    provider
      .request(.userProfile("xavierdk")) { result in
        let json = try? result.value?.mapJSON()

        print("Success results4: \(json)")
        self.expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: json, handler: nil)
    }
    
    waitForExpectations(timeout: 5, handler: nil)
  }
}
