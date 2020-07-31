//
//  MainViewController.swift
//  Chat
//
//  Created by Gabriel Igliozzi on 7/30/20.
//  Copyright © 2020 Gabriel Igliozzi. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    //Prperty of current user signed in
    public var user: User!
    
    //Porfile image
    private let profileImage = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //While we wait for the data to download
        self.setupPlaceholderView()
        
        //Important code to get the user data
        self.handleUserAuthDataRetreive {
            //Data already downloaded
            self.setupView()
        }
    }
    
    //This method will check for the current user auth and data,
    //it will show the auth controller if no user or download the data
    private func handleUserAuthDataRetreive(completion: @escaping () -> Void) {
        if Network.isUserLoggedIn == true {
            Network.retreiveUserData(id: Network.userId!) { (result) in
                switch result {
                case .success(let user): self.user = user
                case .failure(let error): print(error)
                }
                
                completion()
            }
        } else { self.showAuthViewController() }
    }
    
    //Show Auth View Controller as a sheet
    private func showAuthViewController() {
        let authViewController = AuthViewController()
        authViewController.mainViewController = self
        self.present(authViewController, animated: true, completion: nil)
    }
    
}

extension MainViewController {
    
    //Method to configure the view while the data has not been yet downloaded
    private func setupPlaceholderView() {
        
        //Self
        self.view.backgroundColor = .white
        
        //Navigation
    }
    
    private func setupView() {
        
        //Navigation
        self.navigationItem.title = self.user.name
        self.setupProfileImage()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "􀍟", style: .plain, target: self, action: #selector(self.logOut))
        
    }
    
    @objc private func logOut() {
        Network.logOutOfCurrentUser { (error) in
            if error != nil { return print(error?.localizedDescription) }
            self.showAuthViewController()
        }
    }
    
    private func setupProfileImage() {
        profileImage.backgroundColor = .blue
        
        guard let navigationBar = self.navigationController?.navigationBar else { return }
        
        //navigationBar.addSubview(profileImage)
        navigationBar.addSubview(self.profileImage)
        
        profileImage.layer.cornerRadius = Const.ImageSizeForLargeState / 2
        profileImage.clipsToBounds = true
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            profileImage.leftAnchor.constraint(equalTo: navigationBar.leftAnchor, constant: Const.ImageRightMargin),
            profileImage.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: -Const.ImageBottomMarginForSmallState),
            profileImage.heightAnchor.constraint(equalToConstant: Const.ImageSizeForLargeState),
            profileImage.widthAnchor.constraint(equalTo: profileImage.heightAnchor)
            ])
    }
    
    private struct Const {
        /// Image height/width for Large NavBar state
        static let ImageSizeForLargeState: CGFloat = 40
        /// Margin from right anchor of safe area to right anchor of Image
        static let ImageRightMargin: CGFloat = 16
        /// Margin from bottom anchor of NavBar to bottom anchor of Image for Large NavBar state
        static let ImageBottomMarginForLargeState: CGFloat = 12
        /// Margin from bottom anchor of NavBar to bottom anchor of Image for Small NavBar state
        static let ImageBottomMarginForSmallState: CGFloat = 6
        /// Image height/width for Small NavBar state
        static let ImageSizeForSmallState: CGFloat = 32
        /// Height of NavBar for Small state. Usually it's just 44
        static let NavBarHeightSmallState: CGFloat = 44
        /// Height of NavBar for Large state. Usually it's just 96.5 but if you have a custom font for the title, please make sure to edit this value since it changes the height for Large state of NavBar
        static let NavBarHeightLargeState: CGFloat = 96.5
    }
}
