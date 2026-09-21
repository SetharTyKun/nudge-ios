//
//  NotesViewModel.swift
//  NotesApp
//
//  Created by Sethar TyKun on 19/8/26.
//
import Observation
import Foundation

@Observable
final class NotesViewModel {
    var state: ViewState<[NoteResponse]> = .idle
    private let auth: AuthViewModel
    
    init(auth: AuthViewModel) {
        self.auth = auth
    }
    
    func getNote(_ id: Int) async throws -> NoteResponse {
        guard let token = auth.token else { throw URLError(.userAuthenticationRequired) }
        
        let response = try await NoteAPI.fetchNote(id, token)
        
        return response
    }
    
    
    func getNotes(_ limit: Int = 10, _ offset: Int = 0) async throws {
        
        guard let token = auth.token else { throw URLError(.userAuthenticationRequired) }
        
        let response = try await NoteAPI.fetchNotes(token, limit, offset)
    
        state = .loaded(response.notes)
    }
    
    func updateNote(_ id: Int, note: NoteUpdate) async throws -> NoteResponse {
        guard let token = auth.token else { throw URLError(.userAuthenticationRequired) }
        
        let response = try await NoteAPI.updateNote(id, token, note)
        return response
    }
    
    func createNote(_ note: NoteCreate) async throws -> NoteResponse {
        guard let token = auth.token else { throw URLError(.userAuthenticationRequired) }
        
        let response = try await NoteAPI.createNote(token, note)
        return response
    }
    
    func deleteNote(_ id: Int) async throws {
        guard let token = auth.token else { throw URLError(.userAuthenticationRequired) }
        
        try await NoteAPI.deleteNote(token, id)
    }
    
    func resetState() {
        state = .idle
    }
}
