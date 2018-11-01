//
//  Searching.swift
//  ProgrammingAlgorithmTests
//
//  Created by Tony Mu on 1/11/18.
//  Copyright © 2018 Tony Mu. All rights reserved.
//

import XCTest
import Nimble

class Searching: XCTestCase {
  
  override func setUp() {
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }
  
  func testBinarySearch_value_existing() {

    // Arrange
    let numbers = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67]
    
    // Act
    let result = numbers.binarySearch(value: 5)
    
    // Assert
    expect(result).to(equal(2))
    
  }
  
  func testBinarySearch_value_in_left_bound() {
    
    // Arrange
    let numbers = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67]
    
    // Act
    let result = numbers.binarySearch(value: 2)
    
    // Assert
    expect(result).to(equal(0))
    
  }
  
  func testBinarySearch_value_in_right_bound() {
    
    // Arrange
    let numbers = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67]
    
    // Act
    let result = numbers.binarySearch(value: 67)
    
    // Assert
    expect(result).to(equal(18))
    
  }
  
  func testBinarySearch_value_not_existing() {
    // Arrange
    let numbers = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67]
    
    // Act
    let result = numbers.binarySearch(value: 0)
    
    // Assert
    expect(result).to(beNil())
  }
  
  func testPerformanceExample() {
    // This is an example of a performance test case.
    self.measure {
      // Put the code you want to measure the time of here.
    }
  }
  
}
