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
        flowLayout.minimumLineSpacing = 5
        flowLayout.sectionInset = UIEdgeInsets(top: 5, left: 8, bottom: 5, right: 8)
        
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
        
        self.setupViews()
        self.configureDataSource()
        
        Network.observeMessages(from: self.receiver) { (result) in
            switch result {
            case .success(let message):
                self.messages.append(message)
                self.createSnapshot(from: self.messages)
            case .failure(let error): print(error)
            }
        }
    }
    
}

//Handle collectionview delegate and methods
extension ChatViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    private func configureDataSource() {
        let dataSource = UICollectionViewDiffableDataSource<Section, Message>(collectionView: self.collectionView) { (collectionView, indexPath, message) -> UICollectionViewCell? in
            
            guard let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "messageCell", for: indexPath) as? MessagesCollectionViewCell else { return UICollectionViewCell() }
            cell.setupCell(message: message.payload, isSender: message.sender == self.sender.id)
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
    
    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                                 sizeForItemAt indexPath: IndexPath) -> CGSize {
        let chat = self.messages[indexPath.item]
        let size = CGSize(width: 250, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        var estimatedFrame = NSString(string: chat.payload).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)], context: nil)
        estimatedFrame.size.height += 15
        return CGSize(width: self.collectionView.frame.width - 16, height: estimatedFrame.height + 17)
    }
}

//Handle input text view delegate
extension ChatViewController: InputTextViewDelegate {
    internal func didTapSendButton(text: String) {
        Network.sendMessage(message: Message(id: UUID().uuidString, sender: self.sender.id, receiver: self.receiver.id, payload: text))
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

//Handle initialization of user interface views
extension ChatViewController {
    private func setupViews() {
        
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
    }
}
