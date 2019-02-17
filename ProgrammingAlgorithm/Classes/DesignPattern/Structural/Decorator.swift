//
//  Decorator.swift
//  ProgrammingAlgorithm
//
//  Created by Tony Mu on 17/02/19.
//  Copyright © 2019 Tony Mu. All rights reserved.
//

import UIKit

/*
 Decorator: addes additional responsibilities to objects without requiring changes to the type used to create them
 
 Add new behavior to existing types
   - Extend functionality without modifying original code
 Decorators can be implemented via
   - Object wrapping
   - Swift Extension
 */

/*
 Swift extensions
  - Add computed properites
  - Define instance & type methods
  - Provide new initializers
  - Define subscripts
  - Create and use new nested type
  - Mark existing types confrom to an protocol
 
  - CANNOT add or override existing stored property
 */

// e.g. use extension to add tempalture property to dobule
extension Double {
  var celsius: Double { return self }
  var fahrenheit: Double { return (self * 1.8) + 32 }
}
// e.g. add initializer
extension CGVector {
  init(point: CGPoint) {
    self.init(dx: point.x, dy: point.y)
  }
}

extension String {
  subscript (index: Int) -> Character? {
    guard index >= 0 else {
      return nil
    }
    
    guard let idx = self.index(self.startIndex, offsetBy: index, limitedBy: self.endIndex) else {
      return nil
    }
    
    return self[idx]
  }
}

extension UIColor {
  convenience init (hex: UInt32) {
    let divisor = CGFloat(255)
    let red = CGFloat((hex & 0xFF0000) >> 16) / divisor
    let green = CGFloat((hex & 0x00FF00) >> 8) / divisor
    let blue = CGFloat(hex & 0x0000FF) / divisor
    self .init(red: red, green: green, blue: blue, alpha: 1)
  }
}

// e.g. use object wrapping

class BorderedLabelDecorator: UILabel {
  private let wrappedLabel: UILabel
  
  required init(label: UILabel, cornerRadius: CGFloat = 3.0, borderWidth: CGFloat = 1.0, borderColor: UIColor = .black) {
    
    self.wrappedLabel = label
    super.init(frame: label.frame)
    
    wrappedLabel.layer.cornerRadius = cornerRadius
    wrappedLabel.layer.borderColor = borderColor.cgColor
    wrappedLabel.layer.borderWidth = borderWidth
    wrappedLabel.clipsToBounds = true
    
  }
  
  override var textAlignment: NSTextAlignment {
    get {
      return wrappedLabel.textAlignment
    }
    set {
       wrappedLabel.textAlignment = newValue
    }
  }
  
  override var backgroundColor: UIColor? {
    get {
      return wrappedLabel.backgroundColor
    }
    set {
      wrappedLabel.backgroundColor = newValue
    }
  }
  
  override var textColor: UIColor? {
    get {
      return wrappedLabel.textColor
    }
    set {
      wrappedLabel.textColor = newValue
    }
  }
  
  override var layer: CALayer {
    return wrappedLabel.layer
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("not been implemented")
  }
}
