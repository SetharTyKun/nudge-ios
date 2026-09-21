//
//  NoteUpdate.swift
//  NotesApp
//
//  Created by Sethar TyKun on 17/8/26.
//

struct NoteUpdate: Codable {
    var content: String?
    var isPinned: Bool?
    var isCompleted: Bool?
    
    enum CodingKeys: String, CodingKey {
        case content
        case isPinned = "is_pinned"
        case isCompleted = "is_completed"
    }
}
