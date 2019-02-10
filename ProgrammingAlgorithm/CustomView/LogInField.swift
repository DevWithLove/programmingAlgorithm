//
//  LogInField.swift
//  ProgrammingAlgorithm
//
//  Created by Tony Mu on 10/02/19.
//  Copyright © 2019 Tony Mu. All rights reserved.
//

import UIKit

enum FieldType {
  case email
  case password
}

@IBDesignable
class LogInField: UIView {

  // MARK: Properties
  var fieldType: FieldType = .email
 
  @IBInspectable var isEmailType: Bool = true
  
  private let topLabel: UILabel = UILabel()
  private let inputTextField: UITextField = UITextField()
  private let bottomLineView: UIView = UIView()
  
  // MARK: Initializers
  init(frame: CGRect, type: FieldType) {
    self.fieldType = type
    super.init(frame: frame)
    self.setup()
  }
  
  override init(frame: CGRect) {
    super.init(frame:frame)
    self.setup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    self.setup()
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    self.fieldType = self.isEmailType ? .email : .password
    self.setup()
  }
  
  // Default size
  override var intrinsicContentSize: CGSize {
    return CGSize(width: 200, height: 40)
  }
  
  // MARK: UI Methods
  private func setup() {
    self.addSubview(self.topLabel)
    self.topLabel.frame = CGRect(x: 0, y: self.bounds.height/2, width: self.bounds.width, height: 20)
    self.topLabel.alpha = 0
    self.topLabel.text = self.fieldType == .email ? "Email" : "Password"
    self.topLabel.textAlignment = .left
    self.topLabel.textColor = UIColor.blue
    self.topLabel.font = UIFont.systemFont(ofSize: 12)
    
    self.addSubview(inputTextField)
    self.inputTextField.placeholder = self.fieldType == .email ? "Email" : "Password"
    self.inputTextField.isSecureTextEntry = self.fieldType == .password
    self.inputTextField.textAlignment = .left
    self.inputTextField.delegate = self
    self.inputTextField.frame = CGRect(x: 0, y: 19, width: self.bounds.width, height: 20)
    self.inputTextField.addTarget(self, action: #selector(LogInField.checkTopLabel(sender:)), for: .editingChanged)
    
    self.addSubview(bottomLineView)
    self.bottomLineView.backgroundColor = UIColor.lightGray
    self.bottomLineView.frame = CGRect(x: 0, y: self.bounds.height, width: self.bounds.width, height: 1)
    
  }
}

// MARK: UITextField Delegate
extension LogInField: UITextFieldDelegate {
  
  func textFieldDidBeginEditing(_ textField: UITextField) {
    
    if !(textField.text?.isEmpty ?? true) {
      self.topLabel.textColor = UIColor.blue
    }
  
  }
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    
    if !(textField.text?.isEmpty ?? true) {
      self.topLabel.textColor = UIColor.lightGray
    } else {
      UIView.animate(withDuration: 0.25, animations: {
        self.topLabel.alpha = 0
      }, completion:  { done in
        self.topLabel.textColor = UIColor.blue
        self.topLabel.frame = CGRect(x: 0, y: self.bounds.height/2, width: self.bounds.width, height: 1)
      })
    }
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    self.inputTextField.endEditing(true)
    return false
  }
  
  @objc func checkTopLabel(sender: UITextField) {
    guard let isEmpty = sender.text?.isEmpty, isEmpty == false else {
      return
    }
    
    UIView.animate(withDuration: 0.5) {
      self.topLabel.alpha = 1
      self.topLabel.frame = CGRect(x: 0, y: 2, width: self.bounds.width, height: 20)
    }
  }
}
