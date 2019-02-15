//
//  Builder.swift
//  ProgrammingAlgorithmTests
//
//  Created by Tony Mu on 15/02/19.
//  Copyright © 2019 Tony Mu. All rights reserved.
//

import UIKit

/*
 Builder : simplifies the creation of complex objects.
 Separates the creation of an object from its configuration.
 
 Encapsulates default configuration values
 - Create objects which require money configuration values
 - Use when you rarely change most default values
 
 Customizable deefault configuration values
 - Callers can change the defaults
 */


public class ThemeBuilder {
  
  public var backgroundColor: UIColor = UIColor.white
  public var textColor: UIColor = UIColor.black
  public var font: UIFont = UIFont.systemFont(ofSize: 15)
  
  public var theme: Theme {
    get{
       return Theme(backgroundColor: self.backgroundColor, textColor: self.textColor, font: self.font)
    }
  }
  
}

/*
 Usage
 let themeBuilder = ThemeBuilder()
 let defaultTheme = themeBuilder.theme
 
 themeBuilder.backgroundColor = UIColor.yellow
 let yellowTheme = themeBuilder.theme
 */

public class Theme {
  
  public let backgroundColor: UIColor
  public let textColor: UIColor
  public let font: UIFont
  
  
  // Instead provide different init , using default value is better,
  public init(backgroundColor: UIColor = UIColor.white , textColor: UIColor = UIColor.black, font: UIFont = UIFont.systemFont(ofSize: 15)){
    self.backgroundColor = backgroundColor
    self.textColor = textColor
    self.font = font
  }

  
  // -  Bad Code , because there are too many initializer
  //  public init(backgroundColor: UIColor, textColor: UIColor, font: UIFont){
  //    self.backgroundColor = backgroundColor
  //    self.textColor = textColor
  //    self.font = font
  //  }
  //
  //  public convenience init(backgroundColor: UIColor, textColor: UIColor){
  //    self.init(backgroundColor: backgroundColor, textColor: textColor, font: UIFont.systemFont(ofSize: 15))
  //  }
  //
  //  public convenience init(backgroundColor: UIColor){
  //    self.init(backgroundColor: backgroundColor, textColor: UIColor.black)
  //  }
  //
  //  public convenience init(){
  //    self.init(backgroundColor: UIColor.white)
  //  }
  
}

