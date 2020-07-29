//
//  AuthDynamicView.swift
//  Chat
//
//  Created by Gabriel Igliozzi on 7/29/20.
//  Copyright © 2020 Gabriel Igliozzi. All rights reserved.
//

import UIKit

class AuthDynamicView: UIView {
    
    private let inputTextField: UITextField = {
        let textfield = UITextField()
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    
    private let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

extension AuthDynamicView {
    private func setupViews() {
        
        //Self
        self.backgroundColor = .white
        self.layer.cornerRadius = 10
    }
}
