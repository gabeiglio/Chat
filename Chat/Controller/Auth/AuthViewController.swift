//
//  AuthViewController.swift
//  Chat
//
//  Created by Gabriel Igliozzi on 7/29/20.
//  Copyright © 2020 Gabriel Igliozzi. All rights reserved.
//

import UIKit

class AuthViewController: UIViewController {
    
    //Custom UI private properties
    private let slidingButton = SlidingButton()
    private let authView = AuthDynamicView()
    
    //Authview anchor
    private var centerAuthViewAnchor: NSLayoutConstraint?
    private var heightAuthViewAnchor: NSLayoutConstraint?
    private var centerAuthViewAnchorKeyboard: NSLayoutConstraint?
    
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
}

extension AuthViewController: SlidingButtonDelegate {
    func didTapSignInButton() {
        self.heightAuthViewAnchor?.constant -= (self.view.frame.height / 3) / 3
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.authView.hideNameTextfield()
            self.authView.setButtonTitle(name: "Sign in!")
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func didTapCreateButton() {
        self.heightAuthViewAnchor?.constant += (self.view.frame.height / 3) / 3
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.authView.showNameTextfield()
            self.authView.setButtonTitle(name: "Create account!")
            self.view.layoutIfNeeded()
        }, completion: nil)
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
    }
}

//Keyboard notification observers implmentation
extension AuthViewController {
    @objc private func didTapBackgroundView() {
        self.view.endEditing(true)
    }
    
    @objc internal func keyboardWillShow(notification: Notification) {
        
        //Height of the keyboard
        guard let kHeight = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height else
            { return }
        
        //Calculate the center of the availabel space between the top of the keyboard to the top of the view
        let availableSpace = ((self.view.frame.height / 1.5) - kHeight) / 2
        self.centerAuthViewAnchor?.constant -= availableSpace
        
                
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    @objc internal func keyboardWillHide(notification: Notification) {
        //Height of the keyboard
        guard let kHeight = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height else
        { return }
        
        //Calculate the center of the availabel space between the top of the keyboard to the top of the view
        let availableSpace = ((self.view.frame.height / 1.5) - kHeight) / 2
        self.centerAuthViewAnchor?.constant += availableSpace
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}
