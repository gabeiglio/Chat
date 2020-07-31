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
    private var topAuthViewAnchor: NSLayoutConstraint?
    private var centerAuthViewAnchor: NSLayoutConstraint?
    private var heightAuthViewAnchor: NSLayoutConstraint?
    
    //State of keyboard being shown
    private var isKeyboardOut = false
    
    //State of the auth
    private var authState = AuthState.signIn
    
    //Reference to main view controller
    public var mainViewController: MainViewController?
    
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
    
    //Show an alert view with a custom title and error message
    private func showError(with title: String, error: String) {
        let alert = UIAlertController(title: title, message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func authCompletedSuccesfully(id: String) {
        //Get user and feed it to main view controller
        Network.retreiveUserData(id: id) { (result) in
            switch result {
            case .success(let user):
                self.mainViewController?.user = user
                self.dismiss(animated: true) {
                    //like stop an activity indicator?
                }
                
            case .failure(let error): self.showError(with: "Error", error: error.localizedDescription)
            }
        }
    }
}

//Handle auth logic
extension AuthViewController {
    private func signIn(email: String, password: String) {
        Network.signInToAccount(email: email, password: password) { (result) in
            
            switch result {
            case .success(let id): self.authCompletedSuccesfully(id: id)
            case .failure(let error): self.showError(with: "Error", error: error.errorMessage)
            }
            
        }
    }
    
    private func createAccount(name: String, email: String, password: String) {
        Network.createAccount(name: name, email: email, password: password) { (result) in
            switch result {
            case .success(let id): self.authCompletedSuccesfully(id: id)
            case .failure(let error): self.showError(with: "Error", error: error.errorMessage)
            }
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
        self.isModalInPresentation = true
        self.view.backgroundColor = .systemGroupedBackground
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.didTapBackgroundView)))
        
        //Add authView
        self.view.addSubview(self.authView)
        
        //Center anchor
        self.centerAuthViewAnchor = self.authView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        self.centerAuthViewAnchor?.isActive = true
        
        //Top anchor
        self.topAuthViewAnchor = self.authView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 80)
        self.topAuthViewAnchor?.isActive = false
        
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
        
        self.centerAuthViewAnchor?.isActive = false
        self.topAuthViewAnchor?.isActive = true
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
        
        isKeyboardOut = true
    }
    
    @objc internal func keyboardWillHide(notification: Notification) {
        if isKeyboardOut == false { return }
        
        self.centerAuthViewAnchor?.isActive = true
        self.topAuthViewAnchor?.isActive = false
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
        
        isKeyboardOut = false
    }
}
