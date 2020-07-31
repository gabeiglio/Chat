//
//  AuthViewController.swift
//  Chat
//
//  Created by Gabriel Igliozzi on 7/29/20.
//  Copyright © 2020 Gabriel Igliozzi. All rights reserved.
//

import UIKit

class AuthViewController: UIViewController {
    
    //Keep track if the user is singing in or creating an account
    private enum AuthState {
        case signIn
        case create
    }
    
    //Custom UI private properties
    private let actionButton = ActionButton(type: .system)
    private let slidingButton = SlidingButton()
    private let authView = AuthDynamicView()
    
    //Authview anchor
    private var centerAuthViewAnchor: NSLayoutConstraint?
    private var heightAuthViewAnchor: NSLayoutConstraint?
    private var centerAuthViewAnchorKeyboard: NSLayoutConstraint?
    
    //State of keyboard being shown
    private var isKeyboardOut = false
    
    //State of the auth
    private var authState = AuthState.signIn
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Delegate
        self.slidingButton.delegate = self
        
        //Add notifications for keyboard events (hide/show)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        //Setup views for the controller
        self.setupView()
    }
    
    @objc private func didTapActionButton() {
        //Get values of textfields
        do {
            let values = try self.authView.getValuesOfTextfields()
            
            //They are guaranteed to exist
            let name = values["name"]!
            let email = values["email"]!
            let password = values["password"]!
            
            switch self.authState {
            case .create: createAccount(name: name, email: email, password: password)
            case .signIn: signIn(email: email, password: password)
            }
            
            
        } catch let error { print(error.localizedDescription) }
    }
}

//Handle auth logic
extension AuthViewController {
    private func signIn(email: String, password: String) {
        Network.signInToAccount(email: email, password: password) { (result) in
            //Transition and pass user to other view
        }
    }
    
    private func createAccount(name: String, email: String, password: String) {
        Network.createAccount(name: name, email: email, password: password) { (result) in
            //Transition and pass user to other view
        }
    }
}

//Methods of the sliding button delegate
extension AuthViewController: SlidingButtonDelegate {
    internal func didTapSignInButton() {
        self.authState = .signIn
        self.heightAuthViewAnchor?.constant -= (self.view.frame.height / 3) / 3

        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.authView.hideNameTextfield()
            self.view.layoutIfNeeded()
        }) { (completion) in
            self.actionButton.setButtonTitle(name: "Sign in!")
        }
    }
    
    internal func didTapCreateButton() {
        self.authState = .create
        self.heightAuthViewAnchor?.constant += (self.view.frame.height / 3) / 3

        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.authView.showNameTextfield()
            self.view.layoutIfNeeded()
        }) { (completion) in
            self.actionButton.setButtonTitle(name: "Create account!")
        }
    }
}

extension AuthViewController {
    private func setupView() {
        
        //Self
        self.view.backgroundColor = .systemGroupedBackground
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.didTapBackgroundView)))
        
        //Add authView
        self.view.addSubview(self.authView)
        
        //Center anchor
        self.centerAuthViewAnchor = self.authView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        self.centerAuthViewAnchor?.isActive = true
        
        //Height anchor
        self.heightAuthViewAnchor = self.authView.heightAnchor.constraint(equalToConstant: (self.view.frame.height / 3) - (self.view.frame.height / 3) / 3)
        self.heightAuthViewAnchor?.isActive = true
        
        NSLayoutConstraint.activate([
            self.authView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.authView.widthAnchor.constraint(equalToConstant: self.view.frame.width - 40)
        ])
        
        //Add sliding button
        self.view.addSubview(self.slidingButton)
        NSLayoutConstraint.activate([
            self.slidingButton.bottomAnchor.constraint(equalTo: self.authView.topAnchor, constant: -20),
            self.slidingButton.leftAnchor.constraint(equalTo: self.authView.leftAnchor),
            self.slidingButton.rightAnchor.constraint(equalTo: self.authView.rightAnchor),
            self.slidingButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        //Add action Button
        self.view.addSubview(self.actionButton)
        NSLayoutConstraint.activate([
            self.actionButton.topAnchor.constraint(equalTo: self.authView.bottomAnchor, constant: 20),
            self.actionButton.leftAnchor.constraint(equalTo: self.authView.leftAnchor),
            self.actionButton.rightAnchor.constraint(equalTo: self.authView.rightAnchor),
            self.actionButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        self.actionButton.addTarget(self, action: #selector(self.didTapActionButton), for: .touchUpInside)
    }
}

//Keyboard notification observers implmentation
extension AuthViewController {
    @objc private func didTapBackgroundView() {
        self.view.endEditing(true)
    }
    
    @objc internal func keyboardWillShow(notification: Notification) {
        if isKeyboardOut == true { return }
        
        //Height of the keyboard
        guard let kHeight = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height else
            { return }
        
        //Calculate the center of the availabe space between the top of the keyboard to the top of the view (some weird teaking also)
        let availableSpace = ((self.view.frame.height / 1.5) - kHeight) / 2
        self.centerAuthViewAnchor?.constant -= availableSpace
        
                
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
        
        isKeyboardOut = true
    }
    
    @objc internal func keyboardWillHide(notification: Notification) {
        if isKeyboardOut == false { return }
        
        //Height of the keyboard
        guard let kHeight = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height else
        { return }
        
        //Calculate the center of the availabel space between the top of the keyboard to the top of the view (some weird teaking also)
        let availableSpace = ((self.view.frame.height / 1.5) - kHeight) / 2
        self.centerAuthViewAnchor?.constant += availableSpace
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
        
        isKeyboardOut = false
    }
}
