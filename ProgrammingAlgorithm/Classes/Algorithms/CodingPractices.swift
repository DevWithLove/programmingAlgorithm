//
//  CodingPractices.swift
//  ProgrammingAlgorithm
//
//  Created by Tony Mu on 5/02/19.
//  Copyright © 2019 Tony Mu. All rights reserved.
//

import Foundation

class CodingPractices {
    
    // MARK: Find sum from list
    
    /*
     Given a list of numbers and a number k.
     Return whether any two numbers from the list add up to k
    */
    
    func IsSumInList(list:Array<Int>, sum: Int) -> Bool {
        
        // The list must contains 2 elements
        guard list.count > 1 else { return false }
        
        var comps = Set<Int>()
        
        for value in list {
            if comps.contains(value) {
                return true
            }
            comps.insert(sum - value)
        }
        
        return false
    }
}
