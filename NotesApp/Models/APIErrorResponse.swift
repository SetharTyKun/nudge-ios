//
//  APIErrorResponse.swift
//  NotesApp
//
//  Created by Sethar TyKun on 27/8/26.
//
import Foundation

struct APIErrorResponse: Decodable {
    let detail: String
}

// we define this as the response shape from server:
// HTTPException(status_code=409, detail="Username already registered")
