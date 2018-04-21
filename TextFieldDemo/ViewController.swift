//
//  ViewController.swift
//  TextFieldDemo
//
//  Created by Adrian Bolinger on 4/20/18.
//  Copyright © 2018 Adrian Bolinger. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  @IBOutlet weak var textField1: UITextField!
  @IBOutlet weak var textField2: UITextField!
  @IBOutlet weak var textField3: UITextField!
  @IBOutlet weak var textField4: UITextField!
  @IBOutlet weak var textField5: UITextField!
  @IBOutlet weak var textField6: UITextField!
  
  @IBOutlet weak var continueButton: UIButton!
  
  var textFieldArray: [UITextField] {
    return [textField1, textField2, textField3, textField4, textField5, textField6]
  }
  
  // MARK: Lifecycle Methods
  override func viewDidLoad() {
    super.viewDidLoad()
    
    hideKeyboardWhenTappedAround()
    
    // Configure textfields
    textFieldArray.forEach { textField in
      // Your initial setup goes in here
      textField.delegate = self
      textField.keyboardType = .numberPad
      textField.textAlignment = .center
      textField.backgroundColor = UIColor.blue
      textField.tintColor = .clear
      textField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
    }
  }
  
  // MARK: Helpers
  
  func formatTextField(_ textField: UITextField) {
    if let isEmpty = textField.text?.isEmpty {
      switch isEmpty {
      case true:
        textField.backgroundColor = UIColor.blue
        textField.tintColor = .clear
      case false:
        textField.backgroundColor = UIColor.black
        textField.textColor = .white
        textField.tintColor = .clear
      }
    }
  }
  
  func configureActiveField(_ textField: UITextField, isActive: Bool) {
    if isActive == true {
      textField.layer.borderColor = UIColor.red.cgColor
      textField.layer.cornerRadius = 5.0
      textField.layer.borderWidth = 2.0
    } else {
      textField.layer.borderColor = nil
      textField.layer.cornerRadius = 0
      textField.layer.borderWidth = 0
    }
  }
  
  @objc func textFieldDidChange(textField: UITextField) {
    // figure out which textField you're in
    let textFieldIndex = textFieldArray.index(of: textField)
    
    switch textFieldIndex {
    // if it's the last textField (index 5, as indexes start at 0), resign first responder
    case 5:
      textField.resignFirstResponder()
    default:
      textField.resignFirstResponder()
      guard let index = textFieldIndex else { return }
      let nextTextField = textFieldArray[index + 1]
      nextTextField.becomeFirstResponder()
    }
    
    formatTextField(textField)
  }
  
  func enableContinueButton() {
    // chucks bool in array for isEmpty value of each textField
    let isEmptyBools = [textField1, textField2, textField3, textField4, textField5, textField6].compactMap{$0?.text?.isEmpty}
    if isEmptyBools.count == 6 {
      let set = Set(isEmptyBools)
      if set.contains(false) && set.count == 1 {
        continueButton.isEnabled = true
        return // get out of method
      } else {
        continueButton.isEnabled = false
        return // get out of method
      }
    } else {
      continueButton.isEnabled = false
    }
  }
}

// MARK: UITextField Delegate Methods

extension ViewController: UITextFieldDelegate {
  func textFieldDidBeginEditing(_ textField: UITextField) {
    if textField.text?.isEmpty == false {
      textField.selectedTextRange = textField.textRange(from: textField.beginningOfDocument, to: textField.endOfDocument)
    }
    formatTextField(textField)
    configureActiveField(textField, isActive: true)
  }
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    formatTextField(textField)
    configureActiveField(textField, isActive: false)
    enableContinueButton()
  }
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    guard let text = textField.text else { return true }
    
    // Restricts characters to just numbers
    let allowedCharacters = CharacterSet.decimalDigits
    let characterSet = CharacterSet(charactersIn: string)
    
    // Restricts characters to just one
    let newLength = text.count + string.count - range.length
    
    // Test that characters are <= 1 and it's only numbers
    return newLength <= 1 && allowedCharacters.isSuperset(of: characterSet) // Bool
  }
}

// MARK: UIViewController Extension

extension UIViewController {
  func hideKeyboardWhenTappedAround() {
    let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
    tap.cancelsTouchesInView = false
    view.addGestureRecognizer(tap)
  }
  
  @objc func dismissKeyboard() {
    view.endEditing(true)
  }
}

