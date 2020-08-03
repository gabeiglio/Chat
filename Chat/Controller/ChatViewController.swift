//
//  ChatCollectionViewController.swift
//  Chat
//
//  Created by Gabriel Igliozzi on 8/1/20.
//  Copyright © 2020 Gabriel Igliozzi. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController {
    
    private let collectionView: UICollectionView = {
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        
        let collection = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = .white
        collection.register(MessagesCollectionViewCell.self, forCellWithReuseIdentifier: "messageCell")
        return collection
    }()
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, Message>!
    
    private let inputTextView = InputTextView()
    
    public var sender: User!
    public var receiver: User!
    
    private var messages = [Message]()
    
    //Constraints
    private var inputTextBottomConstraint: NSLayoutConstraint?
    private var inputTextHeightConstraint: NSLayoutConstraint?
    
    //Enun for sections
    private enum Section {
        case main
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //Add notifications for keyboard events (hide/show)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        //Delegate
        self.inputTextView.delegate = self
        self.collectionView.delegate = self
        
        //Setup self
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.prefersLargeTitles = false
        
        //Setup inputTextView
        self.view.addSubview(self.inputTextView)
        
        self.inputTextBottomConstraint = self.inputTextView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        self.inputTextBottomConstraint?.isActive = true
        
        self.inputTextHeightConstraint = self.inputTextView.heightAnchor.constraint(equalToConstant: 50)
        self.inputTextHeightConstraint?.isActive = true
        NSLayoutConstraint.activate([
            self.inputTextView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor),
            self.inputTextView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor),
        ])
        
        //Setup collection view
        self.view.addSubview(self.collectionView)
        NSLayoutConstraint.activate([
            self.collectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.collectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.collectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.collectionView.bottomAnchor.constraint(equalTo: self.inputTextView.topAnchor)
        ])
        
        self.configureDataSource()
        self.createSnapshot(from: [Message(id: "1", sender: self.sender, receiver: self.receiver, payload: "Hi how are you"),Message(id: "2", sender: self.sender, receiver: self.receiver, payload: "Hi how are you"),Message(id: "3", sender: self.sender, receiver: self.receiver, payload: "Hi how are you"),Message(id: "4", sender: self.sender, receiver: self.receiver, payload: "Hi how are you"),Message(id: "5", sender: self.sender, receiver: self.receiver, payload: "Hi how are you"),Message(id: "6", sender: self.sender, receiver: self.receiver, payload: "Hi how are you"),Message(id: "7", sender: self.sender, receiver: self.receiver, payload: "Hi how are you"),Message(id: "8", sender: self.sender, receiver: self.receiver, payload: "Hi how are you"),Message(id: "9", sender: self.sender, receiver: self.receiver, payload: "Hi how are you"),Message(id: "10", sender: self.sender, receiver: self.receiver, payload: "Hi how are you"),Message(id: "11", sender: self.sender, receiver: self.receiver, payload: "Hi how are you"),Message(id: "12", sender: self.sender, receiver: self.receiver, payload: "Hi how are you")])
        
        Network.observeMessages { (result) in
            
        }
    }
    
}

//Handle collectionview delegate and methods
extension ChatViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    private func configureDataSource() {
        let dataSource = UICollectionViewDiffableDataSource<Section, Message>(collectionView: self.collectionView) { (collectionView, indexPath, message) -> UICollectionViewCell? in
            
            guard let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "messageCell", for: indexPath) as? MessagesCollectionViewCell else { return UICollectionViewCell() }
            cell.setupCell(message: message.payload)
            return cell
            
        }
        self.dataSource = dataSource
    }
    
    private func createSnapshot(from messages: [Message]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Message>()
        snapshot.appendSections([.main])
        snapshot.appendItems(messages)
        self.dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.frame.size.width / 1.8, height: 50)
    }
    
}

//Handle input text view delegate
extension ChatViewController: InputTextViewDelegate {
    internal func didTapSendButton(text: String) {
        Network.sendMessage(message: Message(id: UUID().uuidString, sender: self.sender, receiver: self.receiver, payload: text))
        self.inputTextHeightConstraint?.constant = 50
        self.view.layoutIfNeeded()
    }
    
    internal func didTapMoreButton() {
        
    }
    
    internal func textViewDidChangeHeight(height: CGFloat) {
        self.inputTextHeightConstraint?.constant += height
        self.view.layoutIfNeeded()
    }
    
}

//Handle Keyboard
extension ChatViewController {
    @objc internal func keyboardWillShow(notification: Notification) {
        guard let keyboardHeight = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height else { return }
        
        if self.inputTextBottomConstraint?.constant == 0 {
            self.inputTextBottomConstraint?.constant = -keyboardHeight + self.view.safeAreaInsets.bottom
            self.view.layoutIfNeeded()
        }
    }
    
    @objc internal func keyboardWillHide(notification: Notification) {
        if self.inputTextBottomConstraint?.constant != 0 {
            self.inputTextBottomConstraint?.constant = 0
            self.view.layoutIfNeeded()
        }
    }
}
