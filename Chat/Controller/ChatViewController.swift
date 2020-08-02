//
//  ChatCollectionViewController.swift
//  Chat
//
//  Created by Gabriel Igliozzi on 8/1/20.
//  Copyright © 2020 Gabriel Igliozzi. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController {
    
    private let inputTextView = InputTextView()
    
    //Constraints
    private var inputTextBottomConstraint: NSLayoutConstraint?
    private var inputTextHeightConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Add notifications for keyboard events (hide/show)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        //Delegate
        self.inputTextView.delegate = self
        
        //Setup self
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.prefersLargeTitles = false
        
        //Setup inputTextView
        self.view.addSubview(self.inputTextView)
        
        self.inputTextBottomConstraint = self.inputTextView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        self.inputTextBottomConstraint?.isActive = true
        
        self.inputTextHeightConstraint = self.inputTextView.heightAnchor.constraint(equalToConstant: 50)
        self.inputTextHeightConstraint?.isActive = true
        NSLayoutConstraint.activate([
            self.inputTextView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor),
            self.inputTextView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor),
        ])
    }
}

//Handle input text view delegate
extension ChatViewController: InputTextViewDelegate {
    internal func didTapSendButton(text: String) {
        
        self.inputTextHeightConstraint?.constant = 0
        self.view.layoutIfNeeded()
    }
    
    internal func textViewDidChangeHeight(height: CGFloat) {
        self.inputTextHeightConstraint?.constant += height
        self.view.layoutIfNeeded()
    }
}

//Handle Keyboard
extension ChatViewController {
    @objc internal func keyboardWillShow(notification: Notification) {
        guard let keyboardHeight = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height else { return }
        
        if self.inputTextBottomConstraint?.constant == 0 {
            self.inputTextBottomConstraint?.constant = -keyboardHeight + self.view.safeAreaInsets.bottom
            self.view.layoutIfNeeded()
        }
    }
    
    @objc internal func keyboardWillHide(notification: Notification) {
        if self.inputTextBottomConstraint?.constant != 0 {
            self.inputTextBottomConstraint?.constant = 0
            self.view.layoutIfNeeded()
        }
    }
}
