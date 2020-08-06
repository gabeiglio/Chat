//
//  MainViewController.swift
//  Chat
//
//  Created by Gabriel Igliozzi on 7/30/20.
//  Copyright © 2020 Gabriel Igliozzi. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    //Current user signed in
    public var user: User!
    private var imagePicker: ImagePicker!
    private let profileImage = ProfileImageView(image: nil)
    private let newMessageButton = FloatingButton(type: .system)
    
    private let tableView = UITableView()
    private var dataSource: UITableViewDiffableDataSource<Section, Chat>!
    
    public var chats = [Chat]()
    
    //Sections
    private enum Section {
        case main
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Show placeholder view while data downloads
        self.setupView()
        
        //Important code to get the user data
        self.handleUserAuthDataRetreive {
            self.loadCurrentUserData()
        }
    }
    
    @objc private func didTapProfileImageView() {
        self.imagePicker.present(from: self.profileImage)
    }
    
    @objc private func didTapNewMessageButton() {
        let contactsController = ContactsTableViewController()
        contactsController.mainViewController = self
        self.present(UINavigationController(rootViewController: contactsController), animated: true, completion: nil)
    }
}

extension MainViewController {
    
    //This method will check for the current user auth and data,
    //it will show the auth controller if no user or download the data
    public func handleUserAuthDataRetreive(completion: @escaping () -> Void) {
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
            
            //Clear all data from user
            self.user = nil
            self.chats = [Chat]()
            
            //Clean user interface
            self.profileImage.image = nil
            
            //Wipe datasource
            self.createSnapshot(from: [], animate: true, completion: nil)
            
            //Final step
            Network.removeObservers()
            self.showAuthViewController()
        }
    }
    
    public func loadCurrentUserData() {
                
        //Profile image view
        Network.retreiveDataFromStorage(path: "profile_pic/\(self.user.id).jpeg") { (result) in
            switch result {
            case .success(let data): self.profileImage.image = UIImage(data: data)
            case .failure(let error): print(error.localizedDescription)
            }
        }
        
        //Here we download all the chats of the current user
        Network.observeChat { (result) in
            switch result {
            case .success(let chat):
                //Check if chat already exist and update
                //TODO -  Find a better swiftier way
                for i in 0..<self.chats.count {
                    if (self.chats[i].friend.id == chat.friend.id) {
                        self.chats[i] = chat
                        return self.createSnapshot(from: self.chats, animate: false, completion: nil)
                    }
                }
                
                //If chat is new then append it
                self.chats.append(chat)
                self.createSnapshot(from: self.chats, animate: true, completion: nil)
                
            case .failure(_): break
            }
        }
    }
    
    public func createNewChat(to user: User) {
        
        let messageController = ChatViewController()
        messageController.sender = self.user
        messageController.receiver = user
        messageController.navigationItem.title = user.name
        messageController.modalPresentationStyle = .fullScreen
                
        for item in self.chats {
            if item.friend.id == user.id {
                return //chat already exist no need to create a new chat, open respective char
            }
        }
        
        self.chats.append(Chat(friend: user, lastMessage: ""))
        self.createSnapshot(from: self.chats, animate: true) {
            self.navigationController?.show(messageController, sender: nil)
        }
    }

    
}

//Handle tableview delegate and datasource methods
extension MainViewController: UITableViewDelegate  {
    
    internal func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let messageController = ChatViewController()
                
        messageController.navigationItem.title = self.chats[indexPath.row].friend.name
        messageController.modalPresentationStyle = .fullScreen
        self.navigationController?.show(messageController, sender: nil)
    }
    
    internal func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return nil
    }
    
    private func configureDataSource() {
        self.dataSource = UITableViewDiffableDataSource<Section, Chat>(tableView: self.tableView, cellProvider: { (tableView, indexPath, chat) -> UITableViewCell? in
            
            guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "chatCell") as? ChatTableViewCell
                else { return UITableViewCell() }
            
            //Get the friend user data
            Network.retreiveUserData(id: chat.friend.id) { (result) in
                switch result {
                case .success(let user):
                    Network.retreiveDataFromStorage(path: "profile_pic/\(user.id).jpeg") { (result) in
                        switch result {
                        case .success(let data): cell.setupCell(image: UIImage(data: data), name: user.name, preview: chat.lastMessage)
                        case .failure(_): cell.setupCell(image: nil, name: user.name, preview: "")
                        }
                    }
                case .failure(let error): print(error.localizedDescription)
                }
            }
            
            return cell
        })
    }
    
    private func createSnapshot(from chats: [Chat], animate: Bool, completion: (() -> Void)?) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Chat>()
        snapshot.appendSections([.main])
        snapshot.appendItems(chats)
        
        dataSource.apply(snapshot, animatingDifferences: animate) {
            if completion != nil {
                completion!()
            }
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
    
    public func setupView() {
        
        //Self
        self.view.backgroundColor = .white
        
        //Navigation bar
        self.navigationItem.title = "Chat"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        //navigation right bar button item
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .plain, target: self, action: #selector(self.logOut))
        
        let wrapper = UIView(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
        wrapper.clipsToBounds = true
        wrapper.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            wrapper.heightAnchor.constraint(equalToConstant: 32),
            wrapper.widthAnchor.constraint(equalToConstant: 32)
        ])
        
        wrapper.addSubview(self.profileImage)
        NSLayoutConstraint.activate([
            self.profileImage.leftAnchor.constraint(equalTo: wrapper.leftAnchor),
            self.profileImage.rightAnchor.constraint(equalTo: wrapper.rightAnchor),
            self.profileImage.topAnchor.constraint(equalTo: wrapper.topAnchor),
            self.profileImage.bottomAnchor.constraint(equalTo: wrapper.bottomAnchor)
        ])
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: wrapper)
        
        //setup profile image gesture recognizer
        self.profileImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.didTapProfileImageView)))
        
        //Initialize picker view
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        
        //Setup tableview
        self.tableView.delegate = self
        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = .clear
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.tableView.register(ChatTableViewCell.self, forCellReuseIdentifier: "chatCell")
        self.view.addSubview(self.tableView)
        
        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        
        //Setup new message button
        self.view.addSubview(self.newMessageButton)
        NSLayoutConstraint.activate([
            self.newMessageButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            self.newMessageButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30),
            self.newMessageButton.heightAnchor.constraint(equalToConstant: 60),
            self.newMessageButton.widthAnchor.constraint(equalToConstant: 60)
        ])
        
        self.newMessageButton.addTarget(self, action: #selector(self.didTapNewMessageButton), for: .touchUpInside)
        
        //Data source
        self.configureDataSource()
    
    }
}
