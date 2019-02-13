//
//  SingletonTests.swift
//  ProgrammingAlgorithmTests
//
//  Created by Tony Mu on 13/02/19.
//  Copyright © 2019 Tony Mu. All rights reserved.
//

import XCTest

class SingletonTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testConcurrentAccesss() {
      // Arrange
      let asyncQueue = DispatchQueue(label: "asyncQueue", attributes: .concurrent, target: nil)
      let expect = expectation(description: "Storing values in sessionstate shall succeed")
      let maxIndex = 200
      
      // Act
      
      for index in 0...maxIndex {
        asyncQueue.async {
          SessionState.shared.set(index, forKey: String(index))
        }
      }
      
      // Assert
      while SessionState.shared.object(forkey: String(maxIndex)) != maxIndex {
        
      }
      
      expect.fulfill()
      waitForExpectations(timeout: 10) { (error) in
         XCTAssertNil(error, "Test expection failed")
      }
      
    }

}
