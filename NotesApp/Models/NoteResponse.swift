//
//  NoteResponse.swift
//  NotesApp
//
//  Created by Sethar TyKun on 17/8/26.
//
import Foundation

struct NoteResponse: Codable, Identifiable {
    let id: Int
    var content: String
    var isPinned: Bool
    var isCompleted: Bool
    let ownerId: Int
    var createdAt: String
    var updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case content
        case isPinned = "is_pinned"
        case isCompleted = "is_completed"
        case ownerId = "owner_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
