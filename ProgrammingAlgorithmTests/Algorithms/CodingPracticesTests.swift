//
//  CodingPractices.swift
//  ProgrammingAlgorithmTests
//
//  Created by Tony Mu on 5/02/19.
//  Copyright © 2019 Tony Mu. All rights reserved.
//

import XCTest
import Nimble

class CodingPracticesTests: XCTestCase {

    let codingPractice = CodingPractices()
    
    // MARK: Find sum from list

    func testFind_sum_from_list_which_list_has_one_element() {
        // Arrange
        let list = [17]
        let sum = 17
        
        // Act
        let result = codingPractice.IsSumInList(list: list, sum: sum)
        
        // Assert
        expect(result).to(beFalse())
    }
    
    func testFind_sum_from_list_which_has_sum_value() {
        // Arrange
        let list = [10,15,3,7]
        let sum = 17
        
        // Act
        let result = codingPractice.IsSumInList(list: list, sum: sum)
        
        // Assert
        expect(result).to(beTrue())
    }
    
    func testFind_sum_from_list_which_list_has_no_smu_value() {
        // Arrange
        let list = [12,9,1,22,4]
        let sum = 17
        
        // Act
        let result = codingPractice.IsSumInList(list: list, sum: sum)
        
        // Assert
        expect(result).to(beFalse())
    }
    
    func testFind_sum_from_list_which_list_which_contains_the_sum() {
        // Arrange
        let list = [12,9,17,22,4]
        let sum = 17
        
        // Act
        let result = codingPractice.IsSumInList(list: list, sum: sum)
        
        // Assert
        expect(result).to(beFalse())
    }

}
