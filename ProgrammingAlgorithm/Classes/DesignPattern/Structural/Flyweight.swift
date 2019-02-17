//
//  Flyweight.swift
//  ProgrammingAlgorithm
//
//  Created by Tony Mu on 17/02/19.
//  Copyright © 2019 Tony Mu. All rights reserved.
//

import Foundation
import os.log

/*
 Flyweight: shares common objects that can be used identically.
 It saves memory by reducing the number of object instances at runtime.
 
 Motivation:
 Share one instance to represent many
 - Separate state-dependent part
 - Store intrinsic/immutable state in the Flyweight object
 - Extrinsic state managed by clients
 - Callers should be able to modify individual state, not the inrinsic one
 
 */

protocol FlyweightLogger {
  var subsystem: String {get}
  var category: String {get}
  
  init(subsystem: String, category: String)
  func log(_ message: String, type: OSLogType, file: String, function: String, line: Int)
}


// Use protocol extension to provide default values for the five function and line arguments.
// Protocol extensions allows us to define behavior on protocol itself, rather than in each conforming type.
extension FlyweightLogger {
  
  func log(_ message: String, type: OSLogType, file: String = #file, function: String = #function, line: Int = #line) {
    return log(message, type: type, file: file, function: function, line: line)
  }
  
}

extension OSLogType: CustomStringConvertible {
  public var description: String {
    switch self {
    case OSLogType.info:
      return "INFO"
    case OSLogType.debug:
      return "DEBUG"
    case OSLogType.error:
      return "ERROR"
    case OSLogType.fault:
      return "FAULT"
    default:
      return "DEFAULT"
    }
  }
}

class Logger: FlyweightLogger {
  let subsystem: String
  let category: String
  private let logger: OSLog
  private let syncQueue = DispatchQueue(label: "com.leakka.logger")
  
  public required init(subsystem: String, category: String = "") {
    self.subsystem = subsystem
    self.category = category
    self.logger = OSLog(subsystem: subsystem, category: category)
  }
  
  func log(_ message: String, type: OSLogType, file: String, function: String, line: Int) {
    syncQueue.sync {
      os_log("%@ [%@ %@ line%d] %@", log: logger, type: type, type.description, file, function, line, message)
    }
  }
}

public class FlyweightLoggerFactory {
  private var loggersByID = Dictionary<String, FlyweightLogger>()
  static var shared = FlyweightLoggerFactory()
  private let syncQueue = DispatchQueue(label: "com.leakka.loggerFactory")
  
  func logger(subsystem: String, category:String = "") -> FlyweightLogger? {
    var result: FlyweightLogger?
    syncQueue.sync {
        let key = subsystem + category
        if let logger = loggersByID[key] {
          result = logger
        } else {
          result = logger(subsystem: subsystem, category: category)
          loggersByID[key] = result
        }
    }
    return result
  }
}
