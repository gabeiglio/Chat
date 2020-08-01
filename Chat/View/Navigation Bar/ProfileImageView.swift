//
//  ProfileImageView.swift
//  Chat
//
//  Created by Gabriel Igliozzi on 7/31/20.
//  Copyright © 2020 Gabriel Igliozzi. All rights reserved.
//

import UIKit

class ProfileImageView: UIImageView {
    
    override init(image: UIImage?) {
        super.init(image: image)
        
        //Setup self
        self.backgroundColor = .lightGray
        self.layer.cornerRadius = Const.ImageSizeForSmallState / 2
        self.clipsToBounds = true
        self.isUserInteractionEnabled = true
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public func setImage(named name: String) {
        self.image = UIImage(named: name)
    }
    
}

extension ProfileImageView {
    public struct Const {
        // Image height/width for Large NavBar state
        static let ImageSizeForLargeState: CGFloat = 40
        // Margin from right anchor of safe area to right anchor of Image
        static let ImageRightMargin: CGFloat = 16
        // Margin from bottom anchor of NavBar to bottom anchor of Image for Large NavBar state
        static let ImageBottomMarginForLargeState: CGFloat = 12
        // Margin from bottom anchor of NavBar to bottom anchor of Image for Small NavBar state
        static let ImageBottomMarginForSmallState: CGFloat = 6
        // Image height/width for Small NavBar state
        static let ImageSizeForSmallState: CGFloat = 32
        // Height of NavBar for Small state. Usually it's just 44
        static let NavBarHeightSmallState: CGFloat = 44
        // Height of NavBar for Large state. Usually it's just 96.5 but if you have a custom font for the title, please make sure to edit this value since it changes the height for Large state of NavBar
        static let NavBarHeightLargeState: CGFloat = 96.5
    }
}
