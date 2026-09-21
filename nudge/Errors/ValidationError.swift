//
//  ValidationError.swift
//  NotesApp
//
//  Created by Sethar TyKun on 28/8/26.
//
import Foundation

enum ValidationError: LocalizedError {
    case emptyUsernameOrEmail
    case invalidEmail
    case emptyPassword
    case emptyVeriedPassword
    case passwordMismatch
    case weakPassword
    case invaliadCredentials
    
    var errorDescription: String? {
        switch self {
        case .emptyUsernameOrEmail:
            return "Username or email cannot be empty."
        case .invalidEmail:
            return "Invalid email."
        case .emptyPassword:
            return "Password cannot be empty."
        case .emptyVeriedPassword:
            return "Verified password cannot be empty."
        case .passwordMismatch:
            return "Passwords do not match."
        case .weakPassword:
            return "Password must be at least 8 characters."
        case .invaliadCredentials:
            return "Invaliad credentials"
        }
    }
}

func isValidEmail(_ email: String) -> Bool {
    let emailRegex = #"^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
    return email.range(of: emailRegex, options: .regularExpression) != nil
}

func validateSignUp(_ username: String,_ email: String,_ password: String,_ verifiedPassword: String) throws {
    guard !username.trimmingCharacters(in: .whitespaces).isEmpty else {
        throw ValidationError.emptyUsernameOrEmail
    }
    
    guard !email.trimmingCharacters(in: .whitespaces).isEmpty else {
        throw ValidationError.emptyUsernameOrEmail
    }
    
    guard isValidEmail(email) else {
        throw ValidationError.invalidEmail
    }
    
    guard !password.trimmingCharacters(in: .whitespaces).isEmpty else {
        throw ValidationError.emptyPassword
    }
    
    guard password.count >= 8 else {
        throw ValidationError.weakPassword
    }
    
    guard !verifiedPassword.trimmingCharacters(in: .whitespaces).isEmpty else {
        throw ValidationError.emptyVeriedPassword
    }
    
    guard password == verifiedPassword else {
        throw ValidationError.passwordMismatch
    }
    
}

func validateSignIn(_ username: String, _ password: String) throws {
    guard !username.trimmingCharacters(in: .whitespaces).isEmpty else {
        throw ValidationError.emptyUsernameOrEmail
    }
    
    guard !password.trimmingCharacters(in: .whitespaces).isEmpty else {
        throw ValidationError.emptyPassword
    }
    
    guard password.count >= 8 else {
        throw ValidationError.weakPassword
    }
}
