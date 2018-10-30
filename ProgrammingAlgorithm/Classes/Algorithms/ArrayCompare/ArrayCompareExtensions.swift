//
//  ArrayCompareExtensions.swift
//  ProgrammingAlgorithm
//
//  Created by Tony Mu on 30/10/18.
//  Copyright © 2018 Tony Mu. All rights reserved.
//

import UIKit

extension Array where Element: Comparable {
  
  func containsSameElements(as other: [Element]) -> Bool {
    return self.count == other.count && self.sorted() == other.sorted()
  }
}
