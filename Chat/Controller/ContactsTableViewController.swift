//
//  ContactsTableViewController.swift
//  Chat
//
//  Created by Gabriel Igliozzi on 8/1/20.
//  Copyright © 2020 Gabriel Igliozzi. All rights reserved.
//

import UIKit

class ContactsTableViewController: UITableViewController {
    
    private var dataSource: UITableViewDiffableDataSource<Section, User>!
    public var mainViewController: MainViewController?
    private var users: [User]!
    
    private enum Section {
        case main
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "New chat"
        
        //Table view
        self.tableView.separatorStyle = .none
        self.tableView.register(ContactTableViewCell.self, forCellReuseIdentifier: "contactCell")
        
        //Configure snapshot and datasource
        self.configureSnapshot()
        self.donwloadUserData()
        
    }
    
}

//Implement the download of the user data
extension ContactsTableViewController {
    private func donwloadUserData() {
        Network.retreiveAllUserData { (result) in
            switch result {
            case .success(let users): self.users = users
            case .failure(let error): print(error.localizedDescription)
            }
            
            //Remove current user id
            for i in 0..<self.users.count - 1 {
                if self.users[i].id == Network.userId! { self.users.remove(at: i) }
            }
            
            self.createSnapshot(from: self.users)
        }
    }
}

//Implement datasource methods
extension ContactsTableViewController {
    
    private func configureSnapshot() {
        self.dataSource = UITableViewDiffableDataSource<Section, User>(tableView: self.tableView, cellProvider: { (tableview, indexPath, user) -> UITableViewCell? in
            guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "contactCell") as? ContactTableViewCell else {
                return UITableViewCell()
            }
            
            //Download user image
            Network.retreiveDataFromStorage(path: "profile_pic/\(user.id).jpeg") { (result) in
                switch result {
                case .success(let data): cell.setupCell(image: UIImage(data: data), name: user.name)
                case .failure(_): cell.setupCell(image: nil, name: user.name)
                }
            }
            
            //Donwload image
            return cell
        })
    }
    
    private func createSnapshot(from users: [User]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, User>()
        snapshot.appendSections([.main])
        snapshot.appendItems(users)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
}

//Implement delegate methods
extension ContactsTableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = self.users[indexPath.row]
        self.dismiss(animated: true) {
            self.mainViewController?.createNewChat(to: user)
        }
    }
}
