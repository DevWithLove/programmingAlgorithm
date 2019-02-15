//
//  Singleton.swift
//  ProgrammingAlgorithm
//
//  Created by Tony Mu on 13/02/19.
//  Copyright © 2019 Tony Mu. All rights reserved.
//

import Foundation

public class SessionState {
  
  /// In-memory storage for key value pairs
  /// However array and dict are not thread safe in Swift
  private var storage = [String: Any]()
  
  /// serializes access to our internal dictionary
  private let asyncQueue = DispatchQueue(label: "asyncQueue", attributes: .concurrent, target: nil)
  
  
  /// Hide Initializer
  private init() {}
  
  /// Swift guarentees that lazily initialized globals or static properties are thread-safe
  /// GCD dispatch_once is not needed to create singletons. and it is no logner avaiable from swift 3
  public static let shared: SessionState = {
    let instance = SessionState()
    return instance
  }()
  
  public func set<T>( _ value: T?, forKey key: String) {
    // synchronize access
    asyncQueue.async( flags: .barrier) {
      if value == nil {
        if self.storage.removeValue(forKey: key) != nil {
          print("Successfully removed value for key \(key)")
        }
      }else {
        print("No value for key \(key)")
      }
      self.storage[key] = value
    }
  }
  
  public func object<T>( forkey key: String) -> T? {
    
    var result : T?
    // synchronize access
    asyncQueue.sync {
      result = storage[key] as? T ?? nil
    }
    
    return result
  }
}

