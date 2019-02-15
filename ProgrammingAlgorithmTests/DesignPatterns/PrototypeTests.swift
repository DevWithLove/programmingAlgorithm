//
//  PrototypeTests.swift
//  ProgrammingAlgorithm
//
//  Created by Tony Mu on 14/02/19.
//  Copyright © 2019 Tony Mu. All rights reserved.
//

import XCTest

public struct MemoryUtil{
  
  #warning("Not for production code")
  public static func address(_ o: UnsafeRawPointer) -> String {
    let address = unsafeBitCast(o, to: Int.self)
    return String(format: "%p", address)
  }
  
  public static func address<T: AnyObject>(_ ref: T) -> String {
    let address = unsafeBitCast(ref, to: Int.self)
    return String(format: "%p", address)
  }
  
}

// MARK: Value Type

fileprivate struct Contact: CustomStringConvertible{
  fileprivate var firstName: String
  fileprivate var lastName: String
  
  fileprivate var description: String {
    return "\(firstName) \(lastName)"
  }
}

extension Contact: Equatable {
  fileprivate static func ==(rhs:Contact, lhs: Contact) -> Bool {
    return rhs.firstName == lhs.firstName &&
      rhs.lastName == lhs.lastName
  }
}

// MARK: Class Type

fileprivate class ContactClass: NSCopying, CustomStringConvertible {
  
  public var firstName: String
  public var lastName: String
  public var workAddress: WorkAddress
  
  public init(firstName: String, lastName: String, workAddress: WorkAddress) {
    self.firstName = firstName
    self.lastName = lastName
    self.workAddress = workAddress
  }
  
  fileprivate var description: String {
    return "\(firstName) \(lastName)"
  }
  
  func copy(with zone: NSZone? = nil) -> Any {
    return ContactClass(firstName: firstName, lastName: lastName, workAddress: workAddress)
  }
  
}

extension ContactClass: Equatable {
  fileprivate static func ==(rhs:ContactClass, lhs: ContactClass) -> Bool {
    return rhs.firstName == lhs.firstName &&
      rhs.lastName == lhs.lastName
  }
}

// MARK: Shallow and deep copy

public class WorkAddress: NSCopying, CustomStringConvertible {
  
  public var streetAddress: String
  public var city: String
  public var zip: String
  
  public init(streetAddress: String, city: String, zip: String) {
    self.streetAddress = streetAddress
    self.city = city
    self.zip = zip
  }
  
  public var description: String {
    return "\(self.streetAddress)"
  }
  
  public func copy(with zone: NSZone? = nil) -> Any {
    return WorkAddress(streetAddress: self.streetAddress, city: self.city, zip: self.zip)
  }
  
}

class PrototypeTests: XCTestCase {
  
  func testPrototype(){
    
    var contactPrototype = Contact(firstName: "Joe", lastName: "Black")
    
    var contactCopy = contactPrototype
    print(MemoryUtil.address(&contactPrototype)) // different memory address
    print(MemoryUtil.address(&contactCopy))
    
    
    // Copy on wirte optimization
    // This technique with delays the copy operation until it's needed so swift
    // can insure that no wasted work is done.
    // this feature specifically added to swift collections, you dont get it for free for custom data types.
    
    var numbers: Array<Int> = [1,2,3]
    var numbersCopy = numbers
    
    print(MemoryUtil.address(numbers))  // both array point to the same data
    print(MemoryUtil.address(numbersCopy))
    
    // However if you change a value of the array, the two array memeory adderess will be different
    numbersCopy.append(4)
    print(MemoryUtil.address(numbers))  // memory addresses are different
    print(MemoryUtil.address(numbersCopy))
    
    // Class type
    var contactClassPrototype = ContactClass(firstName: "Joe", lastName: "Black", workAddress: WorkAddress(streetAddress: "1, brannon street", city: "Los Angeles", zip: "1221"))
    var anotherContactClass = contactClassPrototype
    
    print(MemoryUtil.address(contactClassPrototype))  // memory addresses are Same
    print(MemoryUtil.address(anotherContactClass))
    
    var contactClassCopy = contactClassPrototype.copy() as! ContactClass
    
    print(contactClassPrototype)
    print(contactClassCopy)
    
    // Shallow Copy
    // means that we copied the address of an object rather than cloning the object itself.
    
    
    var contactC = ContactClass(firstName: "Joe", lastName: "Black", workAddress: WorkAddress(streetAddress: "1, brannon street", city: "Los Angeles", zip: "1221"))
    
    var contactCCopy = contactC.copy() as! ContactClass
    print(MemoryUtil.address(contactC))  // memory addresses are different
    print(MemoryUtil.address(contactCCopy)) // however, the workAddress is not copyed, if we change one workaddress, the other workaddress will change as well. both contact.workaddress will point to the same memory address
    
    print(MemoryUtil.address(contactC.workAddress))  // Memory address are same
    print(MemoryUtil.address(contactCCopy.workAddress))
    
    // Deep Copy
    // add copy method to workAddress
    // OR change Address book to struct type
    

    
    
    
  }
  
}
