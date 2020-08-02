//
//  ContactTableViewCell.swift
//  Chat
//
//  Created by Gabriel Igliozzi on 8/1/20.
//  Copyright © 2020 Gabriel Igliozzi. All rights reserved.
//

import UIKit

class ContactTableViewCell: UITableViewCell {
    
    let profileImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 32 / 2
        view.clipsToBounds = true
        view.backgroundColor = .lightGray
        return view
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let separatorView: UIView = {
       let view = UIView()
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        //Self
        self.backgroundColor = .white
        self.selectionStyle = .none
        
        //Setup profile image
        self.addSubview(self.profileImage)
        NSLayoutConstraint.activate([
            self.profileImage.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20),
            self.profileImage.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.profileImage.heightAnchor.constraint(equalToConstant: 32),
            self.profileImage.widthAnchor.constraint(equalToConstant: 32)
        ])
        
        //Setup name label
        self.addSubview(self.nameLabel)
        NSLayoutConstraint.activate([
            self.nameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.nameLabel.leftAnchor.constraint(equalTo: self.profileImage.rightAnchor, constant: 10),
            self.nameLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10),
            self.nameLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        //Separator Inset
        self.addSubview(self.separatorView)
        NSLayoutConstraint.activate([
            self.separatorView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.separatorView.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.separatorView.rightAnchor.constraint(equalTo: self.rightAnchor),
            self.separatorView.heightAnchor.constraint(equalToConstant: 0.5)
        ])
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public func setupCell(image: UIImage?, name: String) {
        self.profileImage.image = image
        self.nameLabel.text = name
    }
    
}

