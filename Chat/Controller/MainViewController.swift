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
    private var imagePicker: ImagePicker!
    private let profileImage = ProfileImageView(image: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Show placeholder view while data downloads
        self.setupPlaceholderView()
        
        //Important code to get the user data
        self.handleUserAuthDataRetreive {
            self.setupView()
        }
    }
    
    @objc private func didTapProfileImageView() {
        self.imagePicker.present(from: self.profileImage)
    }
    
}

//Handle authentication cases
extension MainViewController {
    
    //This method will check for the current user auth and data,
    //it will show the auth controller if no user or download the data
    private func handleUserAuthDataRetreive(completion: @escaping () -> Void) {
        guard Network.isUserLoggedIn == true else { return self.showAuthViewController() }
        
        Network.retreiveUserData(id: Network.userId!) { (result) in
            switch result {
            case .success(let user): self.user = user
            case .failure(let error): print(error)
            }
            
            completion()
        }
    }
    
    //Show Auth View Controller as a sheet
    private func showAuthViewController() {
        let authViewController = AuthViewController()
        authViewController.mainViewController = self
        self.present(authViewController, animated: true, completion: nil)
    }
    
    @objc private func logOut() {
        Network.logOutOfCurrentUser { (error) in
            if error != nil { return print(error!.localizedDescription) }
            self.showAuthViewController()
        }
    }
}

//Handle the image picker delegate method
extension MainViewController: ImagePickerDelegate {
    internal func didSelect(image: UIImage?) {
        guard let compressedImage = image?.jpegData(compressionQuality: 0.25) else { return }
        
        Network.updateUserProfilePhoto(id: self.user.id, image: compressedImage, imageId: self.user.id) { (error) in
            guard error == nil else { return print(error!.localizedDescription) }
            
            self.profileImage.image = image
        }
    }
}

extension MainViewController {
    
    //Method to configure the view while the data has not been yet downloaded
    private func setupPlaceholderView() {
        
        //Self
        self.view.backgroundColor = .systemGroupedBackground
        
        //Navigation bar
        guard let navigationBar = self.navigationController?.navigationBar else { return }

        //profile image for nav bar
        navigationBar.addSubview(self.profileImage)
        NSLayoutConstraint.activate([
            profileImage.leftAnchor.constraint(equalTo: navigationBar.leftAnchor, constant: ProfileImageView.Const.ImageRightMargin),
            profileImage.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: -ProfileImageView.Const.ImageBottomMarginForSmallState),
            profileImage.heightAnchor.constraint(equalToConstant: ProfileImageView.Const.ImageSizeForSmallState),
            profileImage.widthAnchor.constraint(equalTo: self.profileImage.heightAnchor)
        ])
        
        
    }
    
    private func setupView() {
        
        //Navigation
        self.navigationItem.title = self.user.name
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .plain, target: self, action: #selector(self.logOut))
        
        //setup profile image gesture recognizer
        self.profileImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.didTapProfileImageView)))
        
        Network.retreiveDataFromStorage(path: "profile_pic/\(self.user.id).jpeg") { (result) in
            switch result {
            case .success(let data): self.profileImage.image = UIImage(data: data)
            case .failure(let error): print(error.localizedDescription)
            }
        }
        
        //Initialize picker view
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        
    }
}
