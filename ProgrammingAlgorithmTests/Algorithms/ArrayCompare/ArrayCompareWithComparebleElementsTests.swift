//
//  ArrayCompareWithComparebleElementsTests.swift
//  ProgrammingAlgorithmTests
//
//  Created by Tony Mu on 30/10/18.
//  Copyright © 2018 Tony Mu. All rights reserved.
//

import XCTest
import Nimble

class ArrayCompareWithComparebleElementsTests: XCTestCase {
  
  override func setUp() {
    
  }
  
  override func tearDown() {
    
  }
  
  func testArrayCompare_elements_are_same() {
    
    // Arrange
    let number1: [Int] = [1,2,3,4,5]
    let number2: [Int] = [2,1,3,5,4]
    
    // Act
    let result = number1.containsSameElements(as: number2)
    
    // Assert
    expect(result).to(beTrue())
  }
  
  func testArrayCompare_elements_are_not_same() {
    
    // Arrange
    let number1: [Int] = [1,2,3,4,5]
    let number2: [Int] = [2,1,3,5,5]
    
    // Act
    let result = number1.containsSameElements(as: number2)
    
    
    // Assert
    expect(result).to(beFalse())
  }
  
  func testArrayCompare_elements_array_length_is_different() {
    
    // Arrange
    let number1: [Int] = [1,2,3,4,5]
    let number2: [Int] = [1,2,3,4]
    
    // Act
    let result = number1.containsSameElements(as: number2)
    
    // Assert
    expect(result).to(beFalse())
  }
  
  func testPerformanceArrayCompare_with_large_contents() {
  
    // Arrange
    var number1: [Int] = []
    var number2: [Int] = []
    
    for i in 1...100000 {
      number1.append(i)
      number2.append(i)
    }
    
    number1.shuffle()
    number2.shuffle()
    
    // Act
    // Assert
    self.measure {
      let result = number1.containsSameElements(as: number2)
      expect(result).to(beTrue())
    }
  }
  
}
