//
//  SortingTests.swift
//  ProgrammingAlgorithmTests
//
//  Created by Tony Mu on 31/10/18.
//  Copyright © 2018 Tony Mu. All rights reserved.
//

import XCTest
import Nimble

class SortingTests: XCTestCase {
  
  override func setUp() {

  }
  
  override func tearDown() {
 
  }
  
  func testInsertionSort_ascending() {
    // Arrange
    let list = [ 10, -1, 3, 9, 2, 27, 8, 5, 1, 3, 0, 26 ]
    
    // Act
    let sorted = list.insertionSort(<)
    
    // Assert
    expect(sorted).to(haveCount(12))
    expect(sorted).to(beginWith(-1))
    expect(sorted).to(endWith(27))
  }
  
  func testInsertionSort_descending() {
    // Arrange
    let list = [ 10, -1, 3, 9, 2, 27, 8, 5, 1, 3, 0, 26 ]
    
    // Act
    let sorted = list.insertionSort(>)
    
    // Assert
    expect(sorted).to(haveCount(12))
    expect(sorted).to(beginWith(27))
    expect(sorted).to(endWith(-1))
  }
  
  func testPerformanceExample() {
    // This is an example of a performance test case.
    self.measure {
      // Put the code you want to measure the time of here.
    }
  }
  
}
