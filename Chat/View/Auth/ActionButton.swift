//
//  ActionButton.swift
//  Chat
//
//  Created by Gabriel Igliozzi on 7/30/20.
//  Copyright © 2020 Gabriel Igliozzi. All rights reserved.
//

import UIKit

class ActionButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //Setup view self
        self.setTitle("Sign In!", for: .normal)
        self.setTitleColor(.white, for: .normal)
        self.layer.cornerRadius = 10
        self.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        self.backgroundColor = UIColor(red: 255/255, green: 87/255, blue: 34/255, alpha: 1)
        self.translatesAutoresizingMaskIntoConstraints = false
        
    }
        
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    //Set button title, intended for state change
    public func setButtonTitle(name: String) {
        self.setTitle(name, for: .normal)
    }
    
    //Animation for the action button (show/hide)
    public func hideActionButton() {
        self.isEnabled = false
        
        UIView.animate(withDuration: 0.3) {
            self.alpha = 0
        }
    }
    
    public func showActionButton() {
        self.isEnabled = true
        
        UIView.animate(withDuration: 0.3) {
            self.alpha = 1
        }
    }
}
