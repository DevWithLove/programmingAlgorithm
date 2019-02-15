//
//  Factory.swift
//  ProgrammingAlgorithmTests
//
//  Created by Tony Mu on 15/02/19.
//  Copyright © 2019 Tony Mu. All rights reserved.
//

import UIKit

/*
 
 Factory Method selects the implementation class to instantiate based on the
 criteria supplied by the caller. The caller must only know a single type.
 
  Hide Implementation Classes
    - Create new objects without exposing the implementation class
    - Classes must implement a common protocol/base class
 
 */

public protocol ColorPalette {
  var backgroundColor: UIColor {get}
  var textColor: UIColor {get}
}

struct WhiteboardPalette: ColorPalette {
  
  public var backgroundColor: UIColor {
    get{ return UIColor.white }
  }
  
  public var textColor: UIColor {
    get{ return UIColor.black }
  }
}

struct BlackboardPalette: ColorPalette {
  
  public var backgroundColor: UIColor {
    get{ return UIColor.black }
  }
  
  public var textColor: UIColor {
    get{ return UIColor.white }
  }
}

struct MilkCoffeePalette: ColorPalette {
  
  public var backgroundColor: UIColor {
    get{ return UIColor.brown }
  }
  
  public var textColor: UIColor {
    get{ return UIColor.white }
  }
}

public enum ColorThemes {
  case whiteboard
  case blackboard
  case milkCoffee
}

public class PaletteFactory {
  public class func makePalette(theme: ColorThemes) -> ColorPalette{
    switch theme {
    case .whiteboard: return WhiteboardPalette()
    case .blackboard: return BlackboardPalette()
    case .milkCoffee: return MilkCoffeePalette()
    }
  }
}


