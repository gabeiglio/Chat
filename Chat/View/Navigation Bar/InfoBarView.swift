//
//  InfoBarView.swift
//  Chat
//
//  Created by Gabriel Igliozzi on 7/31/20.
//  Copyright © 2020 Gabriel Igliozzi. All rights reserved.
//

import UIKit

class InfoBarView: UIView {
    
    let profileImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //Add profileImage
        self.addSubview(self.profileImage)
        NSLayoutConstraint.activate([
            self.profileImage.topAnchor.constraint(equalTo: self.topAnchor, constant: -5),
        ])
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
