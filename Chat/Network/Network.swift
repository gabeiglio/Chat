//
//  Network.swift
//  Chat
//
//  Created by Gabriel Igliozzi on 7/29/20.
//  Copyright © 2020 Gabriel Igliozzi. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

struct Network {
    
    static public var isUserLoggedIn: Bool = {
        if Auth.auth().currentUser != nil { return true}
        return false
    }()
    
    static public var userId: String? = {
        guard let id = Auth.auth().currentUser?.uid else { return nil }
        return id
    }()
        
    //Mark: Auth services
    static public func signInToAccount(email: String, password: String, completion: @escaping (Result<String,AuthErrorCode>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            
            guard error == nil else {
                guard let errCode = AuthErrorCode(rawValue: error!._code) else { return completion(.failure(.internalError)) }
                return completion(.failure(errCode))
            }
            
            //We just want to pass the unique Id of the user
            guard let id = result?.user.uid else { return completion(.failure(.internalError))}
            completion(.success(id))
        }
    }
    
    static public func createAccount(name: String, email: String, password: String, completion: @escaping (Result<String,AuthErrorCode>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            
            guard error == nil else {
                guard let errCode = AuthErrorCode(rawValue: error!._code) else { return completion(.failure(.internalError)) }
                return completion(.failure(errCode))
            }
            
            //We just want to pass the unique Id of the user
            guard let id = result?.user.uid else { return completion(.failure(.internalError)) }
            
            //Store information in database
            Database.database().reference().child("users").child(id).setValue(["name": name, "email": email, "profile_pic": ""])
            completion(.success(id))
        }
    }
    
    static public func logOutOfCurrentUser(completion: @escaping (Error?) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(nil)
        } catch let error { completion(error) }
    }
    
    //Mark: Database services
    static public func retreiveAllUserData(completion: @escaping (Result<[User], DatabaseError>) -> Void) {
        Database.database().reference().child("users").observeSingleEvent(of: .value) { (snapshot) in
            guard let dict = snapshot.value as? [String: AnyObject] else {
                return completion(.failure(.error))
            }
            
            var users = [User]()
            
            for (key, value) in dict {
                guard let val = value as? [String: AnyObject] else { return completion(.failure(.error)) }
                guard let name = val["name"] as? String, let email = val["email"] as? String, let profilePic = val["profile_pic"] as? String else {
                    return completion(.failure(.error))
                }
                
                users.append(User(id: key, name: name, email: email, profilePic: profilePic))
            }
            
            completion(.success(users))
        }
    }
    
    static public func updateUserData(id: String, with values: [String: Any]) {
        let path = Database.database().reference().child("users").child(id)
        path.updateChildValues(values)
    }
    
    static public func retreiveUserData(id: String, completion: @escaping (Result<User,DatabaseError>) -> Void) {
        Database.database().reference().child("users").child(id).observeSingleEvent(of: .value) { (snapshot) in
            guard let dict = snapshot.value as? [String: AnyObject] else { return completion(.failure(.error)) }
            
            //Unwrap values from snapshot dict
            guard let name = dict["name"] as? String, let email = dict["email"] as? String, let profilePic = dict["profile_pic"] as? String else { return completion(.failure(.error))
            }
            
            //Return succes with user attached
            return completion(.success(User(id: id, name: name, email: email, profilePic: profilePic)))
        }
    }
    
    static public func updateUserProfilePhoto(id: String, image: Data, imageId: String, completion: @escaping (DatabaseError?) -> Void) {
        Network.uploadDataToStorage(name: imageId, data: image, type: "jpeg") { (error) in
            guard error == nil else { return completion(.error) }
            
            Network.updateUserData(id: id, with: ["profile_pic": imageId])
            completion(nil)
        }
    }
    
    static func sendMessage(id: String, sender: String, receiver: String, payload: String) {
        Database.database().reference().child("messages").child(id).setValue([
            "sender":    sender,
            "receiver":  receiver,
            "payload":   payload,
            "timestamp": ServerValue.timestamp()
        ])
        
        Database.database().reference().child("user-messages").child(sender).updateChildValues([id: 0])
        Database.database().reference().child("user-messages").child(receiver).updateChildValues([id: 0])
    }
    
    static func observeChat(completion: @escaping (Result<Chat, DatabaseError>) -> Void) {
        guard let id = Network.userId else { return completion(.failure(.error)) }
        
        Database.database().reference().child("user-messages").child(id).observe(.childAdded) { (messageId) in
            Database.database().reference().child("messages").child(messageId.key).observeSingleEvent(of: .value) { (snapshot) in
                guard let dict = snapshot.value as? [String: AnyObject] else { return completion(.failure(.error)) }
                
                guard let senderId = dict["sender"] as? String, let receiverId = dict["receiver"] as? String, let payload = dict["payload"] as? String else {
                    return completion(.failure(.error))
                }
                //Get friend user
                let friendId = (id != senderId) ? senderId : receiverId
                
                Network.retreiveUserData(id: friendId) { (result) in
                    switch result {
                    case .success(let friend): completion(.success(Chat(friend: friend, lastMessage: payload)))
                    case .failure(_): break
                    }
                }
            }
        }
    }
    
    static func observeMessages(from receiver: User, completion: @escaping (Result<Message,DatabaseError>) -> Void) {
        guard let id = Network.userId else { return completion(.failure(.error)) }
        
        Database.database().reference().child("user-messages").child(id).observe(.childAdded) { (messageId) in
            Database.database().reference().child("messages").child(messageId.key).observeSingleEvent(of: .value) { (snapshot) in
                guard let dict = snapshot.value as? [String: AnyObject] else { return }
                
                guard let senderId = dict["sender"] as? String, let receiverId = dict["receiver"] as? String, let payload = dict["payload"] as? String else {
                    return completion(.failure(.error))
                }
                
                //Get date from timestap
                guard let date = dict["timestamp"] as? TimeInterval else { return completion(.failure(.error)) }
                
                print(Date(timeIntervalSince1970: date/1000))
                if (senderId == id || senderId == receiver.id) && (receiverId == id || receiverId == receiver.id) {
                    let message = Message(id: snapshot.key, sender: senderId, receiver: receiverId, payload: payload, timestamp: Date(timeIntervalSince1970: date/1000))
                    return completion(.success(message))
                }
    
            }
        }
    }
    
    static func removeObservers() {
        Database.database().reference().child("user-messages").removeAllObservers()
    }
    
    //Mark: Storage services
    static public func uploadDataToStorage(name: String, data: Data, type: String, completion: @escaping (StorageError?) -> Void) {
        Storage.storage().reference().child("profile_pic").child("\(name).\(type)").putData(data, metadata: nil) { (metadata, error) in
            guard let _ = metadata else { return completion(.error) }
            completion(nil)
        }
    }
    
    static public func retreiveDataFromStorage(path: String, completion: @escaping (Result<Data,StorageError>) -> Void) {
        Storage.storage().reference().child(path).getData(maxSize: 1 * 1024 * 1024) { (data, error) in
            guard error == nil, let final = data else { return completion(.failure(.error)) }
            completion(.success(final))
        }
    }
    
    
}
