//
//  Token.swift
//  NotesApp
//
//  Created by Sethar TyKun on 17/8/26.
//

struct Token: Codable {
    var accessToken: String
    var tokenType: String
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
    }
}
