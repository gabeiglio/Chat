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

enum AuthError: Error {
    case wrongCredentials
    case noConnection
    case invalidPassword
    case invalidEmail
}

struct Network {
        
    //Mark: Auth services
    static public func signInToAccount(email: String, password: String, completion: @escaping (Result<String,AuthError>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            guard error == nil else { return completion(.failure(.wrongCredentials)) }
            
            //We just want to pass the unique Id of the user
            guard let id = result?.user.uid else { return completion(.failure(.wrongCredentials))}
            completion(.success(id))
        }
    }
    
    static public func createAccount(name: String, email: String, password: String, completion: @escaping (Result<String,AuthError>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            guard error == nil else { return completion(.failure(.wrongCredentials)) }
            
            //We just want to pass the unique Id of the user
            guard let id = result?.user.uid else { return completion(.failure(.wrongCredentials)) }
            
            //Store information in database
            Database.database().reference().child("users").child(id).setValue(["name": name, "email": email])
            completion(.success(id))
        }
    }
    
    //Mark: Database services
    
    
}
