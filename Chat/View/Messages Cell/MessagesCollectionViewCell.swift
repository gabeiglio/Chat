//
//  MessagesCollectionViewCell.swift
//  Chat
//
//  Created by Gabriel Igliozzi on 8/2/20.
//  Copyright © 2020 Gabriel Igliozzi. All rights reserved.
//

import UIKit

class MessagesCollectionViewCell: UICollectionViewCell {
    
    private let textView: UITextView = {
        let textview = UITextView()
        textview.backgroundColor = .clear
        textview.tintColor = .white
        textview.isEditable = false
        textview.translatesAutoresizingMaskIntoConstraints = false
        textview.font = UIFont.systemFont(ofSize: 15)
        return textview
    }()
    
    private let container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //Constraints
    var rightConstraint: NSLayoutConstraint?
    var leftConstraint: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //Setup view
        self.addSubview(self.container)
        
        //Setup container
        self.container.layer.cornerRadius = 5
        self.rightConstraint = self.container.rightAnchor.constraint(equalTo: self.rightAnchor)
        self.rightConstraint?.isActive = true
        
        self.leftConstraint = self.container.leftAnchor.constraint(equalTo: self.leftAnchor)
        self.leftConstraint?.isActive = true
        
        NSLayoutConstraint.activate([
            self.container.topAnchor.constraint(equalTo: self.topAnchor),
            self.container.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
                
        //Setup textview
        self.container.addSubview(self.textView)
        NSLayoutConstraint.activate([
            self.textView.leftAnchor.constraint(equalTo: self.container.leftAnchor, constant: 5),
            self.textView.rightAnchor.constraint(equalTo: self.container.rightAnchor, constant: -5),
            self.textView.topAnchor.constraint(equalTo: self.container.topAnchor, constant: 5),
            self.textView.bottomAnchor.constraint(equalTo: self.container.bottomAnchor, constant: -5)
        ])
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public func setupCell(message: String, isSender: Bool) {
        self.textView.text = message
        
        if isSender {
            self.container.backgroundColor = UIColor(red: 255/255, green: 87/255, blue: 34/255, alpha: 1)
            self.textView.textAlignment = .right
            self.leftConstraint?.constant += self.frame.size.width / 3
            self.textView.textColor = .black
        } else {
            self.container.backgroundColor = .blue
            self.textView.textAlignment = .left
            self.rightConstraint?.constant -= self.frame.size.width / 3
            self.textView.textColor = .white
        }
    }
}
