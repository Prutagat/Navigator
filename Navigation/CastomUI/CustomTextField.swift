//
//  CustomTextField.swift
//  Navigation
//
//  Created by Алексей Голованов on 30.07.2023.
//

import UIKit

final class CustomTextField: UITextField {
    
    init(placeholderText: String, text: String = "", isSecureTextEntry: Bool = false) {
        super.init(frame: .zero)
        textFieldSetup(placeholderText: placeholderText, textDefault: text, isSecure: isSecureTextEntry)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func textFieldSetup(placeholderText: String, textDefault: String, isSecure: Bool) {
        backgroundColor = .systemGray6
        clipsToBounds = true
        borderStyle = UITextField.BorderStyle.roundedRect
        autocapitalizationType = .none
        tintColor = UIColor(named: "new_color_set")
        translatesAutoresizingMaskIntoConstraints = false
        autocorrectionType = UITextAutocorrectionType.no
        keyboardType = UIKeyboardType.default
        returnKeyType = UIReturnKeyType.done
        clearButtonMode = UITextField.ViewMode.whileEditing
        contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        placeholder = placeholderText.localized
        isSecureTextEntry = isSecure
        text = textDefault.localized
    }
}
