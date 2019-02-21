//
//  Stack.swift
//  ProgrammingAlgorithm
//
//  Created by Tony Mu on 30/10/18.
//  Copyright © 2018 Tony Mu. All rights reserved.
//

import UIKit

struct Stack<T> {

  fileprivate var elements = [T]()
  // Used by Iterator Protocol
  fileprivate var currentIndex: Int = 0

  var count: Int {
    return elements.count
  }
  
  var isEmpty: Bool {
    return elements.isEmpty
  }
  
  var top: T? {
    return elements.last
  }
  
  mutating func push(_ element:T) {
    elements.append(element)
  }
  
  mutating func  pop() -> T? {
    return elements.popLast()
  }
  
}

// Sequence protocol - defines requirements for sequential access to its elements
//extension Stack: Sequence {
//    // this iterator provides sequential access to the elements of the internal array
//    // the following way using the array iterator, but we may need to make custom iterator
////    public func makeIterator() -> Array<T>.Iterator {
////         return elements.makeIterator()
////    }
//
//    // Use custom Iterator, rather than Array Iterator
//    public func makeIterator() -> StackIterator<T> {
//        return StackIterator(elements)
//    }
//}

// Iterator protocol - provides a unified interface for accessing the elements of a sequence one at a time
// Custom Satck Iterator
//struct StackIterator<T>: IteratorProtocol {
//    private var elements: [T]
//    private var currentIndex: Int = 0
//    
//    init(_ elements: [T]) {
//        self.elements = elements
//    }
//    
//    mutating func next() -> T? {
//        guard currentIndex < elements.count else { return nil }
//        
//        let element = elements[currentIndex]
//        currentIndex += 1
//        
//        return element
//    }
//}

// We could extend both sequence and Iterator protocol to avoid crate StackIterator type
extension Stack: Sequence, IteratorProtocol {
    mutating func next() -> T? {
        guard currentIndex < elements.count else { return nil }
        
        let element = elements[currentIndex]
        currentIndex += 1
        
        return element
    }
}


private func IteratorSample() {
    
    var stack = Stack<Int>()
    
    stack.push(1)
    stack.push(2)
    stack.push(3)
    
    for n in stack {
        print(n)
    }
    
}
