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
    
    
}
