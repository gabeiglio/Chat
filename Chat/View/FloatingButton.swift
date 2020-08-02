//
//  FloatingButton.swift
//  Chat
//
//  Created by Gabriel Igliozzi on 8/1/20.
//  Copyright © 2020 Gabriel Igliozzi. All rights reserved.
//

import UIKit

class FloatingButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //Self
        self.translatesAutoresizingMaskIntoConstraints = false
        self.tintColor = .white
        self.setImage(UIImage(systemName: "pencil"), for: .normal)
        self.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.backgroundColor = UIColor(red: 255/255, green: 87/255, blue: 34/255, alpha: 1)
        
        //Shadow
        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
        self.layer.masksToBounds = false
        self.layer.cornerRadius = 4.0
        
        self.layer.cornerRadius = 60 / 2

    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
}
