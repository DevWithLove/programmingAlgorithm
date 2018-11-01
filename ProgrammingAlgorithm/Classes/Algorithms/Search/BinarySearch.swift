//
//  BinarySearch.swift
//  ProgrammingAlgorithm
//
//  Created by Tony Mu on 1/11/18.
//  Copyright © 2018 Tony Mu. All rights reserved.
//

import UIKit

extension Array where Element : Comparable {
  
  func binarySearch(value: Element) -> Int? {
    let array = self.sorted()
    var lowerBound = 0
    var upperBound = array.count
    
    while lowerBound < upperBound {
      let midIndex = lowerBound + (upperBound - lowerBound) / 2
      if array[midIndex] == value {
        return midIndex
      }
      
      if array[midIndex] < value {
        lowerBound = midIndex + 1
        continue
      }
      
      upperBound = midIndex
    }
    
    return nil
  }
}
