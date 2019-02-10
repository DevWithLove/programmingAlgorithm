//
//  ViewController.swift
//  ProgrammingAlgorithm
//
//  Created by Tony Mu on 30/10/18.
//  Copyright © 2018 Tony Mu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  @IBOutlet weak var emailLoginField: LogInField!
  @IBOutlet weak var LoginButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
 
// If not using auto layout
//  override func viewWillLayoutSubviews() {
//    self.emailField.frame = CGRect(x: self.view.bounds.width/2 - 100, y: self.view.center.y - 20, width: 200, height: 40 )
//    self.passwordField.frame = CGRect(x: self.view.bounds.width/2 - 100, y: self.view.center.y + 20, width: 200, height: 40)
//  }
  
  
  @IBAction func attempLogin(_ sender: Any) {
    emailLoginField.executeClosureIfEmailIsValid {
       LoginButton.setTitle("It worked", for: .normal)
    }
  }
  
}

