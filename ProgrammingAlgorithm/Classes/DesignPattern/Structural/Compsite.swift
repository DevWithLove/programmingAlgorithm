//
//  Compsite.swift
//  ProgrammingAlgorithm
//
//  Created by Tony Mu on 17/02/19.
//  Copyright © 2019 Tony Mu. All rights reserved.
//

import Foundation

/*
 Composite: allows related individual objects and collections of objects to be treated uniformly
 
 Motivation:
 Create hierarchical recuresive tree structures
  - Objects can represent a leaf or a composite
  - Manage collections and individual objects in a uniform manner
  - All objects in the composite must implement the same interface
 
 */

//class File: CustomStringConvertible {
//  private let name: String
//  private var nestingLevel: Int = 0
//
//  init(name: String) {
//    self.name = name
//  }
//
//  func nesting(level: Int) {
//    self.nestingLevel = level
//  }
//
//  var description: String {
//    let nesting = String(repeating: "\t", count: nestingLevel) + "_ "
//    return "\(nesting)\(name) (" + String(format: "%.1f", (Float(size)/1024/1024)) + "MB)"
//  }
//
//  lazy var size = UInt32.random(in: 1...10000)
//
//}
//
//class Directory: CustomStringConvertible{
//  private let name: String
//  private var nestingLevel: Int = 0
//  private var entries = Array<AnyObject>()
//
//  init(name:String) {
//    self.name = name
//  }
//  
//  func nesting(level: Int) {
//    self.nestingLevel = level
//  }
//
//  func add(entry: AnyObject){
//    if let fileEntry = entry as? File {
//      fileEntry.nesting(level: nestingLevel + 1)
//    } else if let dirEntry = entry as? Directory {
//      dirEntry.nesting(level: nestingLevel + 1)
//    } else {
//      return
//    }
//  }
//
//  var description: String {
//    var result = String(repeating: "\t", count: nestingLevel) + "[+] \(name)" + String(format: "%.1f", (Float(size)/1024/1024)) + "MB)"
//
//    for entry in self.entries {
//      if let fileEntry = entry as? File {
//        result += "\n\(fileEntry)"
//      } else if let dirEntry = entry as? Directory {
//        result += "\n\(dirEntry)"
//      }
//    }
//    
//    return result
//  }
//  
//  var size: UInt32 {
//    var result: UInt32 = 0
//
//    for entry in self.entries {
//      if let fileEntry = entry as? File {
//        result += fileEntry.size
//      } else if let dirEntry = entry as? Directory {
//        result += dirEntry.size
//      }
//    }
//    return result
//  }
//}

// Issue about implemention the directoy class must know the file class and we have to check types of each entry

//MARK: Solution

protocol FileSystemEntry: CustomStringConvertible {
  init(name: String)
  func nesting(level: Int)
  var size: UInt32{get}
}

class File: FileSystemEntry {
  private let name: String
  private var nestingLevel: Int = 0
  
  required init(name: String) {
    self.name = name
  }
  
  func nesting(level: Int) {
    self.nestingLevel = level
  }
  
  var description: String {
    let nesting = String(repeating: "\t", count: nestingLevel) + "_ "
    return "\(nesting)\(name) (" + String(format: "%.1f", (Float(size)/1024/1024)) + "MB)"
  }
  
  lazy var size = UInt32.random(in: 1...10000)
  
}

class Directory: FileSystemEntry{
  private let name: String
  private var nestingLevel: Int = 0
  private var entries = Array<FileSystemEntry>()
  
  required init(name:String) {
    self.name = name
  }
  
  func nesting(level: Int) {
    self.nestingLevel = level
  }
  
  func add(entry: FileSystemEntry){
    entry.nesting(level: self.nestingLevel + 1)
    entries.append(entry)
  }
  
  var description: String {
    var result = String(repeating: "\t", count: nestingLevel) + "[+] \(name)" + String(format: "%.1f", (Float(size)/1024/1024)) + "MB)"
    
    for entry in self.entries {
      result += "\n\(entry)"
    }
    
    return result
  }
  
  var size: UInt32 {
    var result: UInt32 = 0
    
    for entry in self.entries {
      result += entry.size
    }
    return result
  }
}

