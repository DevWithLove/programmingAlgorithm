//
//  File.swift
//  ProgrammingAlgorithm
//
//  Created by Tony Mu on 17/02/19.
//  Copyright © 2019 Tony Mu. All rights reserved.
//

import Foundation

/*
 
 Adapter: maps an existing interface to another interface.
 
 Motivation:
 
 Third-party/legacy code
 - We cannot modify the interface, but we have to integrate it in our
 app/framework
 Adapt the incompatible interface
 - Create adapter that gives the required interface.
 - The adapter extends or wraps the incompatible entity.
 
 */

protocol Sharing {
  func share(message: String, completionHandler: @escaping (Error?)-> Void)
}

class FBSharer: Sharing {
  func share(message: String, completionHandler: @escaping (Error?) -> Void) {
    print("Message \(message) shared on Facebook")
    completionHandler(nil)
  }
}

class TwitterSharer: Sharing {
  func share(message: String, completionHandler: @escaping (Error?) -> Void) {
    print("Message \(message) shared on Twitter")
    completionHandler(nil)
  }
}

enum SharerType: String, CustomDebugStringConvertible {
  case facebook = "Facebook"
  case twitter = "Twitter"
  case reddit = "Reddit"
  
  public var debugDescription: String {
    switch self {
      case .facebook: return "Facebook sharer"
      case .twitter: return "Twitter sharer"
      case .reddit: return "Reddit poster"
    }
  }
}

class Sharer {
  // I cannot directly add reddit on the list, relying on polymorphism as we did.
  // So instead, we us RedditPosterAdapter
  private let shareServices: [SharerType: Sharing] = [.facebook: FBSharer(), .twitter: TwitterSharer(), .reddit: RedditPosterAdapter()]
  
  public func shareEverywhere(message: String) {
    for (type, sharer) in shareServices {
      sharer.share(message: message) { (error) in
        if error != nil {
          print("Error while sharing \(message) via \(type)")
        }
      }
    }
  }
  
  public func share(message: String, serviceType: SharerType, completionHandler: @escaping (Error?)-> Void) {
    if let service = shareServices[serviceType] {
      service.share(message: message, completionHandler: completionHandler)
    }
  }
}

// Third- party RedditPoster class

class RedditPoster {
  public func post(text: String, completion: @escaping (Error?, UUID?) ->Void) {
    print("Message \(text) posted to Raddit")
    completion(nil, UUID())
  }
}

class RedditPosterAdapter: Sharing {
  
  private lazy var redditPoster = RedditPoster()
  
  func share(message: String, completionHandler: @escaping (Error?) -> Void) {
    redditPoster.post(text: message) { (error, uuid) in
      completionHandler(error)
    }
  }
}

//MARK:Another Approach by using extension

// we could not directly using RedditPoster in the shareServices List. no Adapter needed. 
extension RedditPoster: Sharing {
  public func share(message: String, completionHandler: @escaping (Error?) -> Void) {
    self.post(text: message) { (error, uuid) in
      completionHandler(error)
    }
  }
}
