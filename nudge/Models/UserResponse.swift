//
//  UserResponse.swift
//  NotesApp
//
//  Created by Sethar TyKun on 17/8/26.
//

struct UserResponse: Codable {
    let id: Int
    var username: String
    var email: String
    var createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case username
        case email
        case createdAt = "created_at"
    }
}
