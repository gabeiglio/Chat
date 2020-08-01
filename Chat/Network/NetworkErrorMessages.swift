//
//  NetworkErrorMessages.swift
//  Chat
//
//  Created by Gabriel Igliozzi on 7/31/20.
//  Copyright © 2020 Gabriel Igliozzi. All rights reserved.
//

import FirebaseAuth

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
            return "An error has accurred, please try again later"
        default:
            return "Unknown error occurred"
        }
    }
}

enum DatabaseError: Error {
    case error
}

enum StorageError: Error {
    case error
}
