//
//  AuthDynamicView.swift
//  Chat
//
//  Created by Gabriel Igliozzi on 7/29/20.
//  Copyright © 2020 Gabriel Igliozzi. All rights reserved.
//

import UIKit

enum InputError: Error {
    case invalidInput
}

class AuthDynamicView: UIView {
    
    private let emailTextField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Write your email"
        textfield.autocapitalizationType = UITextAutocapitalizationType.none
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    
    private let nameTextField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Here goes your name"
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    
    private let passwordTextfield: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "And for last the password"
        textfield.isSecureTextEntry = true
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    //Animation for name textfield (show/hide)
    public func hideNameTextfield() {
        self.nameTextField.isHidden = true
    }
    
    public func showNameTextfield() {
        self.nameTextField.isHidden = false
    }
    
    //Getter of the values of the textfields
    public func getValuesOfTextfields() throws -> [String:String] {
        guard let name = self.nameTextField.text, let email = self.emailTextField.text, let password = self.passwordTextfield.text else {
            throw InputError.invalidInput
        }
        return ["name":name,"email":email,"password":password]
    }

}

extension AuthDynamicView {
    private func setupViews() {
        
        //Self
        self.backgroundColor = .white
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.translatesAutoresizingMaskIntoConstraints = false
        
        //Initial state
        self.hideNameTextfield()
        
        //Calculate height of textfields (3)
        let textFieldHeight = ((UIScreen.main.bounds.height / 3) / 3) - 20
        
        //Password textfield
        self.addSubview(self.passwordTextfield)
        NSLayoutConstraint.activate([
            self.passwordTextfield.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20),
            self.passwordTextfield.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10),
            self.passwordTextfield.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10),
            self.passwordTextfield.heightAnchor.constraint(equalToConstant: textFieldHeight),
        ])
        
        //Email textfield
        self.addSubview(self.emailTextField)
        NSLayoutConstraint.activate([
            self.emailTextField.bottomAnchor.constraint(equalTo: self.passwordTextfield.topAnchor, constant: -10),
            self.emailTextField.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10),
            self.emailTextField.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10),
            self.emailTextField.heightAnchor.constraint(equalToConstant: textFieldHeight),
        ])
        
        //Name textfield
        self.addSubview(self.nameTextField)
        NSLayoutConstraint.activate([
            self.nameTextField.bottomAnchor.constraint(equalTo: self.emailTextField.topAnchor, constant: -10),
            self.nameTextField.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10),
            self.nameTextField.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10),
            self.nameTextField.heightAnchor.constraint(equalToConstant: textFieldHeight),
        ])

    }
}
