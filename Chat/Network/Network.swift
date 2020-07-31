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

extension AuthErrorCode: Error {
    var errorMessage: String {
        switch self {
        case .emailAlreadyInUse:
            return "The email is already in use with another account"
        case .userNotFound:
            return "Account not found for the specified user. Please check and try again"
        case .userDisabled:
            return "Your account has been disabled. Please contact support."
        case .invalidEmail, .invalidSender, .invalidRecipientEmail:
            return "Please enter a valid email"
        case .networkError:
            return "Network error. Please try again."
        case .weakPassword:
            return "Your password is too weak. The password must be 6 characters long or more."
        case .wrongPassword:
            return "Your password is incorrect. Please try again or use 'Forgot password' to reset your password"
        case .internalError:
            return "An error has acourred, please try again later"
        default:
            return "Unknown error occurred"
        }
    }
}

enum DatabaseError: Error {
    case error
}

struct Network {
        
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
            Database.database().reference().child("users").child(id).setValue(["name": name, "email": email])
            completion(.success(id))
        }
    }
    
    //Mark: Database services
    static public func updateUser(id: String, with values: [String: Any]) {
        let path = Database.database().reference().child("users").child(id)
        path.updateChildValues(values)
    }
    
    
}
