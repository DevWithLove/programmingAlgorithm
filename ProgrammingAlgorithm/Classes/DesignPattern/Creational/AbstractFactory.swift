//
//  AbstractFactory.swift
//  ProgrammingAlgorithmTests
//
//  Created by Tony Mu on 16/02/19.
//  Copyright © 2019 Tony Mu. All rights reserved.
//

import UIKit

/*
 
 The abstract factory design pattern is similar to the Factory Method design pattern, but it hides
 the classes which were involved in the creation process.
 
 Motivation:
 create objects which belong to a group, but inherit from several different base classes
 or implement different protocols. The actual calsses whhich are used to create the objects remained hidden, which lets us modify the factory without having to refactor the caller's code.
 
 Crates a group of related objects
  - Similar to the factory method pattern, but produces a set of objects.
 
 Hides the Factory classes
 - Ability to modify the classes used to create the objects without changing the callers.
 */


protocol Finish: CustomStringConvertible {
  var color: UIColor {get}
  var price: Float {get}
  
  var description: String {get}
}

struct WhiteFinish: Finish {
  var color = UIColor.white
  var price = Float(300)
  
  var description: String = "\n\tFinish: White"
}

struct BlackFinish: Finish {
  var color = UIColor.black
  var price = Float(300)
  
  var description: String = "\n\tFinish: Black"
}

//MARK: Storage

protocol Storage: CustomStringConvertible {
  var type: StorageType {get}
  var size: StorageSize {get}
  var price: Float {get}
}

enum StorageType: String, CustomStringConvertible {
  case flash = "flash"
  case hardDisk = "hard disk"
  
  var description: String {
    return self.rawValue
  }
}

enum StorageSize: String, CustomStringConvertible {
  case small = "512GB"
  case medium = "1TB"
  case huge = "2TB"
  
  var description: String {
    return self.rawValue
  }
}

struct SmallFlash: Storage {
  var type = StorageType.flash
  var size = StorageSize.small
  var price = Float(500)
  
  var description: String {
    return "\n\tStorage: \(size) \(type)"
  }
}

struct MediumFlash: Storage {
  var type = StorageType.flash
  var size = StorageSize.medium
  var price = Float(650)
  
  var description: String {
    return "\n\tStorage: \(size) \(type)"
  }
}

struct SmallHardDisk: Storage {
  var type = StorageType.hardDisk
  var size = StorageSize.small
  var price = Float(650)
  
  var description: String {
    return "\n\tStorage: \(size) \(type)"
  }
}

//MARK: Processor

protocol Processor: CustomStringConvertible {
  var type: ProcessorType {get}
  var frequency: ProcessorFrequency {get}
  var price: Float {get}
}

enum ProcessorType: String, CustomStringConvertible {
  case deaulCore = "Dual Core"
  case quadCore = "Quad Core"
  
  var description: String {
    return self.rawValue
  }
}

enum ProcessorFrequency: String, CustomStringConvertible {
  case low = "14GHz"
  case fast = "2.4GHz"
  case turbo = "3.2GHz"
  
  var description: String {
    return self.rawValue
  }
}

struct BasicProcessor: Processor {
  var type = ProcessorType.deaulCore
  var frequency = ProcessorFrequency.low
  var price = Float(250)
  
  public var description: String {
    return "\n\tProcessor: \(type) \(frequency)"
  }
}

struct FasterProcessor: Processor {
  var type = ProcessorType.deaulCore
  var frequency = ProcessorFrequency.fast
  var price = Float(320)
  
  public var description: String {
    return "\n\tProcessor: \(type) \(frequency)"
  }
}

struct TurboProcessor: Processor {
  var type = ProcessorType.deaulCore
  var frequency = ProcessorFrequency.turbo
  var price = Float(490)
  
  public var description: String {
    return "\n\tProcessor: \(type) \(frequency)"
  }
}

struct HighEndProcessor: Processor {
  var type = ProcessorType.quadCore
  var frequency = ProcessorFrequency.turbo
  var price = Float(900)
  
  public var description: String {
    return "\n\tProcessor: \(type) \(frequency)"
  }
}

//MARK: Memory

protocol Memory: CustomStringConvertible {
  var size: MemorySize {get}
  var type: MemoryType {get}
  var frequency: MemorySpeed {get}
  var price: Float {get}
}

enum MemorySize: String, CustomStringConvertible {
  case basic = "8GB"
  case medium = "16GB"
  case pro = "32GB"
  
  var description: String {
    return self.rawValue
  }
}

enum MemoryType: String, CustomStringConvertible {
  case ddr3 = "DDR3"
  case lpddr3 = "LPDDR3"
  
  var description: String {
    return self.rawValue
  }
}

enum MemorySpeed: String, CustomStringConvertible {
  case fast = "1400MHz"
  case turbo = "1600MHz"
  
  var description: String {
    return self.rawValue
  }
}

struct BasicMemory: Memory {
  var size = MemorySize.basic
  var type = MemoryType.ddr3
  var frequency = MemorySpeed.fast
  
  var price = Float(200)
  
  var description: String {
    return "\n\tMemory:\(size) \(type) \(frequency)"
  }
}


//MARK: Computer

struct Computer: CustomStringConvertible {
  var finish: Finish
  var storage: Storage
  var processor: Processor
  var memory: Memory
  var price: Float {
    get {
      let total = finish.price + storage.price + processor.price + memory.price
      return total
    }
  }
  
  var description: String {
    return "\nYour configuration: \(finish) \(storage) \(processor) \(memory) \nTotal: $\(price)"
  }
}

enum ComputerType {
  case basic
  case office
  case developer
  case highEnd
}

class ComputerFactory {
  
  func makeFinish() -> Finish? {
    return nil
  }
  
  func makeStorage() -> Storage? {
    return nil
  }
  
  func makeProcessor() -> Processor? {
    return nil
  }
  
  func makeMemory()-> Memory? {
    return nil
  }
  
  final class func makeFactory(type: ComputerType) -> ComputerFactory {
    var factory: ComputerFactory
    switch type {
      case .basic: factory = BasicComputerFactory()
      case .office: factory = OfficeComputerFactory()
      case .developer: factory = DeveloperComputerFactory()
      case .highEnd: factory = HighEndComputerFactory()
    }
    return factory
  }
}

fileprivate class BasicComputerFactory: ComputerFactory {
  override func makeFinish() -> Finish? {
    return WhiteFinish()
  }
  
  override func makeStorage() -> Storage? {
    return SmallHardDisk()
  }
  
  override func makeProcessor() -> Processor? {
    return BasicProcessor()
  }
  
  override func makeMemory()-> Memory? {
    return BasicMemory()
  }
}

fileprivate class OfficeComputerFactory: ComputerFactory {
  override func makeFinish() -> Finish? {
    return WhiteFinish()
  }
  
  override func makeStorage() -> Storage? {
    return SmallHardDisk()
  }
  
  override func makeProcessor() -> Processor? {
    return BasicProcessor()
  }
  
  override func makeMemory()-> Memory? {
    return BasicMemory()
  }
}

fileprivate class DeveloperComputerFactory: ComputerFactory {
  override func makeFinish() -> Finish? {
    return WhiteFinish()
  }
  
  override func makeStorage() -> Storage? {
    return SmallHardDisk()
  }
  
  override func makeProcessor() -> Processor? {
    return BasicProcessor()
  }
  
  override func makeMemory()-> Memory? {
    return BasicMemory()
  }
}

fileprivate class HighEndComputerFactory: ComputerFactory {
  override func makeFinish() -> Finish? {
    return WhiteFinish()
  }
  
  override func makeStorage() -> Storage? {
    return SmallHardDisk()
  }
  
  override func makeProcessor() -> Processor? {
    return BasicProcessor()
  }
  
  override func makeMemory()-> Memory? {
    return BasicMemory()
  }
}

//MARK: How to use it

func makeComputerSample() {
  
  let basicComputerFactory = ComputerFactory.makeFactory(type: .basic)
  
  if let finish = basicComputerFactory.makeFinish(),
     let storage = basicComputerFactory.makeStorage(),
     let processor = basicComputerFactory.makeProcessor(),
     let memory = basicComputerFactory.makeMemory() {
    
    let computer = Computer(finish: finish, storage: storage, processor: processor, memory: memory)
    print(computer)
  }
  
}
