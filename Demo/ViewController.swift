//
//  ViewController.swift
//  Demo
//
//  Created by Xavier De Koninck on 25/10/2017.
//  Copyright © 2017 Xavier De Koninck. All rights reserved.
//

import UIKit
import Moya
import MoyaStubbable

class ViewController: UIViewController {
  
  let provider = MoyaProvider<GitHubAPI>(stubClosure: { _ in .immediate },
                                         plugins: [NetworkRecorderPlugin()])
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Now we try to use our stubs, if there isn't any files matching we will
    // get empty NSData, which will be an empty response.
    // Here we change the name to check if we get the stub with "sunshinejr"
    // or the actual response with "test" username.
        
//    provider
//      .request(.userProfile("xavierdk")) { result in
//        let json = try? result.value?.mapJSON()
//
//        print("Success results: \(json)")
//    }
//
//    provider
//      .request(.failableUserProfile("xavierdk")) { result in
//        let json = try? result.value?.mapJSON()
//
//        print("Success results: \(json)")
//    }
  }
}

