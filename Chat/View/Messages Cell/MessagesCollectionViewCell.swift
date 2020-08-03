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
        return textview
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.cornerRadius = 10
        self.backgroundColor = UIColor(red: 255/255, green: 87/255, blue: 34/255, alpha: 1)
        
        //Setup textview
        self.addSubview(self.textView)
        NSLayoutConstraint.activate([
            self.textView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 5),
            self.textView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -5),
            self.textView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            self.textView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5)
        ])
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public func setupCell(message: String) {
        self.textView.text = message
    }
}
