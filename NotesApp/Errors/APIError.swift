//
//  APIError.swift
//  NotesApp
//
//  Created by Sethar TyKun on 28/8/26.
//

import Foundation

enum APIError: LocalizedError {
    case server(String)
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .server(let message):
            return message
        case .unknown:
            return "Please try again."
        }
    }
}


//  protocol LocalizedError: Error {
//      var errorDescription: String? { get }
//      var failureReason: String? { get }
//      var recoverySuggestion: String? { get }
//      var helpAnchor: String? { get }
//  }
