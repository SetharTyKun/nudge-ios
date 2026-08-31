//
//  NoteListResponse.swift
//  NotesApp
//
//  Created by Sethar TyKun on 17/8/26.
//

struct NoteListResponse: Codable {
    var notes: [NoteResponse]
    var total: Int
    var limit: Int
    var offset: Int
}
