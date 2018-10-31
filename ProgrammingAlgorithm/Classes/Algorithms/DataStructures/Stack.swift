//
//  Stack.swift
//  ProgrammingAlgorithm
//
//  Created by Tony Mu on 30/10/18.
//  Copyright © 2018 Tony Mu. All rights reserved.
//

import UIKit

struct Stack<T> {

  private var elements = [T]()

  var count: Int {
    return elements.count
  }
  
  var isEmpty: Bool {
    return elements.isEmpty
  }
  
  var top: T? {
    return elements.last
  }
  
  mutating func push(element:T) {
    elements.append(element)
  }
  
  mutating func  pop() -> T? {
    return elements.popLast()
  }
  
}
