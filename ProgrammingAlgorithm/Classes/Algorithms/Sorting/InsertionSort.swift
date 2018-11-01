//
//  Sorting.swift
//  ProgrammingAlgorithm
//
//  Created by Tony Mu on 31/10/18.
//  Copyright © 2018 Tony Mu. All rights reserved.
//

import UIKit

extension Array where Element: Comparable {
  
  // Less faster using swapAt
//  func insertionSort() -> [Element] {
//    var array = self
//    for index in 1..<array.count {
//      var arrayIndex = index
//      while arrayIndex > 0 && array[arrayIndex] < array[arrayIndex - 1] {
//        array.swapAt(arrayIndex-1, arrayIndex)
//        arrayIndex -= 1
//      }
//    }
//    return array
//  }
  
  /*
   Insertion sort is actually very fast for sorting small arrays. Some standard libraries have sort functions that switch from a quicksort to insertion sort when the partition size is 10 or less.
  */
  func insertionSort(_ isOrderedBefore: (Element,Element)-> Bool) ->[Element] {
    var array = self
    for index in 1..<array.count {
      var arrayIndex = index
      let temp = array[arrayIndex]
      while arrayIndex > 0 && isOrderedBefore(temp, array[arrayIndex - 1]) {
        array[arrayIndex] = array[arrayIndex - 1]
        arrayIndex -= 1
      }
      array[arrayIndex] = temp
    }
    return array
  }
}
