//
//  InputTextMessage.swift
//  Chat
//
//  Created by Gabriel Igliozzi on 8/1/20.
//  Copyright © 2020 Gabriel Igliozzi. All rights reserved.
//

import UIKit

class InputTextMessage: UIView {
    
    private let separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
        return view
    }()
    
    private let inputTextfield: UITextField = {
        let field = UITextField()
        field.placeholder = "Write a message"
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    private let sendButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "paperplane.fill"), for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 20 / 2
        button.backgroundColor = UIColor(red: 255/255, green: 87/255, blue: 34/255, alpha: 1)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //Self
        self.translatesAutoresizingMaskIntoConstraints = false
        
        //Setup separator view
        self.addSubview(self.separatorView)
        NSLayoutConstraint.activate([
            self.separatorView.topAnchor.constraint(equalTo: self.topAnchor),
            self.separatorView.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.separatorView.rightAnchor.constraint(equalTo: self.rightAnchor),
            self.separatorView.heightAnchor.constraint(equalToConstant: 0.5)
        ])
        
        //Setup input textfield
        self.addSubview(self.inputTextfield)
        NSLayoutConstraint.activate([
            self.inputTextfield.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.inputTextfield.topAnchor.constraint(equalTo: self.topAnchor),
            self.inputTextfield.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.inputTextfield.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -40)
        ])
        
        //Setup send button
        self.addSubview(self.sendButton)
        NSLayoutConstraint.activate([
            self.sendButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.sendButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -5),
            self.sendButton.heightAnchor.constraint(equalToConstant: 20),
            self.sendButton.widthAnchor.constraint(equalToConstant: 20)
        ])
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}
