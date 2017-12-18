//
//  MoyaStubbableTests.swift
//  MoyaStubbableTests
//
//  Created by Xavier De Koninck on 18/12/2017.
//  Copyright © 2017 Xavier De Koninck. All rights reserved.
//

import XCTest
import Moya
import RxSwift
import RxMoya
import RxTest
import RxBlocking
@testable import MoyaStubbable

class MoyaStubbableTests: XCTestCase {
  
  override func setUp() {
    super.setUp()
  }
  
  override func tearDown() {
    super.tearDown()
  }
  
  func testRecording() {
    
    // Way to record
    let providerRecorder = MoyaProvider<GitHubAPI>(plugins: [NetworkRecorderPlugin()])
    let stringRecorded = try! providerRecorder.rx.request(.userProfile("XavierDK"))
      .mapString()
      .toBlocking()
      .first()
    let stringRecordedFailed = try! providerRecorder.rx.request(.failableUserProfile("XavierDK"))
      .mapString()
      .toBlocking()
      .first()
    
    // Way to play
    let providerPlayer = MoyaProvider<GitHubAPI>(stubClosure: { _ in .immediate })
    let stringRead = try! providerPlayer.rx.request(.userProfile("XavierDK"))
      .mapString()
      .toBlocking()
      .first()
    let stringReadFailed = try! providerPlayer.rx.request(.failableUserProfile("XavierDK"))
      .mapString()
      .toBlocking()
      .first()
    
    XCTAssert(stringRecorded == stringRead)
    XCTAssert(stringRecordedFailed == stringReadFailed)
  }
  
  func testStorytelling() {
    
    // Way to play a storytelling
    
    let storytelling = [
      StubStory(success: false, code: 404, name: "Story1"),
      StubStory(success: true, code: 200, name: "Story2")
    ]
    let providerRecorder = MoyaProvider<GitHubAPI>(plugins: [NetworkStorytellingPlugin(stubsStory: storytelling)])
    
    
    // First time request is played
    // It will failed
    do {
      let _ = try providerRecorder.rx.request(.userProfile("XavierDK"))
        .mapJSON()
        .toBlocking()
        .first()
      XCTAssert(false)
    }
    catch {
      XCTAssert(error.localizedDescription == "Status code didn't fall within the given range.")
    }

    // Second time request is played
    // It will succeed
    let success = try! providerRecorder.rx.request(.userProfile("XavierDK"))
      .mapJSON()
      .toBlocking()
    .first() as! [String:String]
    
    XCTAssert(success["message"] == "It succeed!")
  }
}
