//
//  MaskTextFieldViewController.swift
//  ProgrammingAlgorithm
//
//  Created by Tony Mu on 9/05/19.
//  Copyright © 2019 Tony Mu. All rights reserved.
//

import UIKit

class MaskTextFieldViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    
    var formatter = AccountNumberTextFieldFormater()
    
    var mastTextField: SwiftMaskTextfield = {
        let textFiled = SwiftMaskTextfield(frame: .zero)
        textFiled.borderStyle = .roundedRect
        textFiled.formatPattern = "##-####-####-##"
        return textFiled
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textField.addTarget(self, action: #selector(textDidChange(sender:)), for: .editingChanged)
        
        view.addSubview(mastTextField)
        _ = mastTextField.anchor(view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 10, leftConstant: 10, bottomConstant: 0, rightConstant: 10, widthConstant: 0, heightConstant: 50)
    }

    @objc fileprivate func textDidChange(sender: UITextField) {
        if let value = formatter.formatText(newText: sender.text) {
            sender.text = value
        }
    }
}

protocol TextFieldPatternFormater {
    var digitsReplecementChar: String { get }
    var formatPattern: String { get }
    var prefix: String { get }
    var maxLength: Int { get }
    //func formatText(text: String) -> String
}

class AccountNumberTextFieldFormater : TextFieldPatternFormater {
    
    var digitsReplecementChar: String = "#"
    
    var formatPattern: String = "##-####-####-##"
    
    var prefix: String = ""
    
}

extension TextFieldPatternFormater {
    
    var maxLength: Int {
        return formatPattern.count + prefix.count
    }
    
    private func getOnlyDigitsString(_ string: String) -> String {
        let charactersArray = string.components(separatedBy: CharacterSet.decimalDigits.inverted)
        return charactersArray.joined(separator: "")
    }
    
    private func getFilteredString(_ string: String) -> String {
        let charactersArray = string.components(separatedBy: CharacterSet.alphanumerics.inverted)
        return charactersArray.joined(separator: "")
    }
    
    private func getStringWithoutPrefix(_ string: String) -> String {
        if string.range(of: self.prefix) != nil {
            if string.count > self.prefix.count {
                let prefixIndex = string.index(string.endIndex, offsetBy: (string.count - self.prefix.count) * -1)
                return String(string[prefixIndex...])
            } else if string.count == self.prefix.count {
                return ""
            }
            
        }
        return string
    }
    
    func formatText(newText: String?) -> String? {
        var currentTextForFormatting = ""
        
        if let text = newText {
            if text.count > 0 {
                currentTextForFormatting = self.getStringWithoutPrefix(text)
            }
        }
        
        if self.maxLength > 0 {
            var formatterIndex = self.formatPattern.startIndex, currentTextForFormattingIndex = currentTextForFormatting.startIndex
            var finalText = ""
            
            currentTextForFormatting = self.getFilteredString(currentTextForFormatting)
            
            if currentTextForFormatting.count > 0 {
                while true {
                    let formatPatternRange = formatterIndex ..< formatPattern.index(after: formatterIndex)
                    let currentFormatCharacter = String(self.formatPattern[formatPatternRange])
                    
                    let currentTextForFormattingPatterRange = currentTextForFormattingIndex ..< currentTextForFormatting.index(after: currentTextForFormattingIndex)
                    let currentTextForFormattingCharacter = String(currentTextForFormatting[currentTextForFormattingPatterRange])
                    
                    switch currentFormatCharacter {
                    case self.digitsReplecementChar:
                        let filteredChar = self.getOnlyDigitsString(currentTextForFormattingCharacter)
                        if !filteredChar.isEmpty {
                            finalText += filteredChar
                            formatterIndex = formatPattern.index(after: formatterIndex)
                        }
                        currentTextForFormattingIndex = currentTextForFormatting.index(after: currentTextForFormattingIndex)
                    default:
                        finalText += currentFormatCharacter
                        formatterIndex = formatPattern.index(after: formatterIndex)
                    }
                    
                    if formatterIndex >= self.formatPattern.endIndex ||
                        currentTextForFormattingIndex >= currentTextForFormatting.endIndex {
                        break
                    }
                }
            }
            
            if finalText.count > 0 {
                return "\(self.prefix)\(finalText)"
            }
    
            return finalText
        }
        return nil
    }
    
}

open class SwiftMaskTextfield : UITextField {
    
    //**************************************************
    // MARK: - Properties
    //**************************************************
    
    public let lettersAndDigitsReplacementChar: String = "*"
    public let anyLetterReplecementChar: String = "@"
    public let lowerCaseLetterReplecementChar: String = "a"
    public let upperCaseLetterReplecementChar: String = "A"
    public let digitsReplecementChar: String = "#"
    
    /**
     Var that holds the format pattern that you wish to apply
     to some text
     
     If the pattern is set to "" no mask would be applied and
     the textfield would behave like a normal one
     */
    @IBInspectable open var formatPattern: String = ""
    
    /**
     Var that holds the prefix to be added to the textfield
     
     If the prefix is set to "" no string will be added to the beggining
     of the text
     */
    @IBInspectable open var prefix: String = ""
    
    /**
     Var that have the maximum length, based on the mask set
     */
    open var maxLength: Int {
        get {
            return formatPattern.count + prefix.count
        }
    }
    
    /**
     Overriding the var text from UITextField so if any text
     is applied programmatically by calling formatText
     */
    override open var text: String? {
        set {
            super.text = newValue
            self.formatText()
        }
        
        get {
            return super.text
        }
    }
    
    //**************************************************
    // MARK: - Constructors
    //**************************************************
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    deinit {
        self.deRegisterForNotifications()
    }
    
    //**************************************************
    // MARK: - Private Methods
    //**************************************************
    
    fileprivate func setup() {
        self.registerForNotifications()
    }
    
    fileprivate func registerForNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(textDidChange),
                                               name: NSNotification.Name(rawValue: "UITextFieldTextDidChangeNotification"),
                                               object: self)
    }
    
    fileprivate func deRegisterForNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc fileprivate func textDidChange() {
        self.undoManager?.removeAllActions()
        self.formatText()
    }
    
    fileprivate func getOnlyDigitsString(_ string: String) -> String {
        let charactersArray = string.components(separatedBy: CharacterSet.decimalDigits.inverted)
        return charactersArray.joined(separator: "")
    }
    
    fileprivate func getOnlyLettersString(_ string: String) -> String {
        let charactersArray = string.components(separatedBy: CharacterSet.letters.inverted)
        return charactersArray.joined(separator: "")
    }
    
    fileprivate func getUppercaseLettersString(_ string: String) -> String {
        let charactersArray = string.components(separatedBy: CharacterSet.uppercaseLetters.inverted)
        return charactersArray.joined(separator: "")
    }
    
    fileprivate func getLowercaseLettersString(_ string: String) -> String {
        let charactersArray = string.components(separatedBy: CharacterSet.lowercaseLetters.inverted)
        return charactersArray.joined(separator: "")
    }
    
    fileprivate func getFilteredString(_ string: String) -> String {
        let charactersArray = string.components(separatedBy: CharacterSet.alphanumerics.inverted)
        return charactersArray.joined(separator: "")
    }
    
    fileprivate func getStringWithoutPrefix(_ string: String) -> String {
        if string.range(of: self.prefix) != nil {
            if string.count > self.prefix.count {
                let prefixIndex = string.index(string.endIndex, offsetBy: (string.count - self.prefix.count) * -1)
                return String(string[prefixIndex...])
            } else if string.count == self.prefix.count {
                return ""
            }
            
        }
        return string
    }
    
    //**************************************************
    // MARK: - Self Public Methods
    //**************************************************
    
    /**
     Func that formats the text based on formatPattern
     
     Override this function if you want to customize the behaviour of
     the class
     */
    open func formatText() {
        var currentTextForFormatting = ""
        
        if let text = super.text {
            if text.count > 0 {
                currentTextForFormatting = self.getStringWithoutPrefix(text)
            }
        }
        
        if self.maxLength > 0 {
            var formatterIndex = self.formatPattern.startIndex, currentTextForFormattingIndex = currentTextForFormatting.startIndex
            var finalText = ""
            
            currentTextForFormatting = self.getFilteredString(currentTextForFormatting)
            
            if currentTextForFormatting.count > 0 {
                while true {
                    let formatPatternRange = formatterIndex ..< formatPattern.index(after: formatterIndex)
                    let currentFormatCharacter = String(self.formatPattern[formatPatternRange])
                    
                    let currentTextForFormattingPatterRange = currentTextForFormattingIndex ..< currentTextForFormatting.index(after: currentTextForFormattingIndex)
                    let currentTextForFormattingCharacter = String(currentTextForFormatting[currentTextForFormattingPatterRange])
                    
                    switch currentFormatCharacter {
                    case self.lettersAndDigitsReplacementChar:
                        finalText += currentTextForFormattingCharacter
                        currentTextForFormattingIndex = currentTextForFormatting.index(after: currentTextForFormattingIndex)
                        formatterIndex = formatPattern.index(after: formatterIndex)
                    case self.anyLetterReplecementChar:
                        let filteredChar = self.getOnlyLettersString(currentTextForFormattingCharacter)
                        if !filteredChar.isEmpty {
                            finalText += filteredChar
                            formatterIndex = formatPattern.index(after: formatterIndex)
                        }
                        currentTextForFormattingIndex = currentTextForFormatting.index(after: currentTextForFormattingIndex)
                    case self.lowerCaseLetterReplecementChar:
                        let filteredChar = self.getLowercaseLettersString(currentTextForFormattingCharacter)
                        if !filteredChar.isEmpty {
                            finalText += filteredChar
                            formatterIndex = formatPattern.index(after: formatterIndex)
                        }
                        currentTextForFormattingIndex = currentTextForFormatting.index(after: currentTextForFormattingIndex)
                    case self.upperCaseLetterReplecementChar:
                        let filteredChar = self.getUppercaseLettersString(currentTextForFormattingCharacter)
                        if !filteredChar.isEmpty {
                            finalText += filteredChar
                            formatterIndex = formatPattern.index(after: formatterIndex)
                        }
                        currentTextForFormattingIndex = currentTextForFormatting.index(after: currentTextForFormattingIndex)
                    case self.digitsReplecementChar:
                        let filteredChar = self.getOnlyDigitsString(currentTextForFormattingCharacter)
                        if !filteredChar.isEmpty {
                            finalText += filteredChar
                            formatterIndex = formatPattern.index(after: formatterIndex)
                        }
                        currentTextForFormattingIndex = currentTextForFormatting.index(after: currentTextForFormattingIndex)
                    default:
                        finalText += currentFormatCharacter
                        formatterIndex = formatPattern.index(after: formatterIndex)
                    }
                    
                    if formatterIndex >= self.formatPattern.endIndex ||
                        currentTextForFormattingIndex >= currentTextForFormatting.endIndex {
                        break
                    }
                }
            }
            
            if finalText.count > 0 {
                super.text = "\(self.prefix)\(finalText)"
            } else {
                super.text = finalText
            }
            
            if let text = self.text {
                if text.count > self.maxLength {
                    super.text = String(text[text.index(text.startIndex, offsetBy: self.maxLength)])
                }
            }
        }
    }
}
