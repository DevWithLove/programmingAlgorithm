//
//  Queue.swift
//  ProgrammingAlgorithm
//
//  Created by Tony Mu on 30/10/18.
//  Copyright © 2018 Tony Mu. All rights reserved.
//

import UIKit

struct Queue<T> {

  private var elements = [T]()
  
  var isEmpty: Bool {
    return elements.isEmpty
  }
  
  var count: Int {
    return elements.count
  }
  
  var front: T? {
    return elements.first
  }
  
  mutating func enqueue(element: T) {
    elements.append(element)
  }
  
  mutating func dequeue() -> T? {
    return isEmpty ? nil : elements.removeFirst()
  }
  
}
