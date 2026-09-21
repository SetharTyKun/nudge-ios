//
//  NoteCreate.swift
//  NotesApp
//
//  Created by Sethar TyKun on 17/8/26.
//

struct NoteCreate: Encodable {
    var content: String
    var isPinned: Bool = false
    var isCompleted: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case content
        case isPinned = "is_pinned"
        case isCompleted = "is_completed"
    }
}
