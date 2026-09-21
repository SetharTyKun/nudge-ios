//
//  APIClient.swift
//  NotesApp
//
//  Created by Sethar TyKun on 17/8/26.
//

// Steps: Build the URL → Configure the URLRequest (method + headers) → Encode the body → Send with URLSession → Check the response → Decode the result
// Decode: RAW → REAL
// Encode: REAL → RAW

import Foundation

class NoteAPI {
    static private let baseURL = Config.baseURL
    
    // Register
    static func register(_ user: UserCreate) async throws -> UserResponse {
        let url = URL(string: baseURL + "/users/register")
        
        guard let url else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(user)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            if let apiError = try? JSONDecoder().decode(APIErrorResponse.self, from: data) {
                throw APIError.server(apiError.detail)
            }
            
            throw APIError.unknown
        }
        
        return try JSONDecoder().decode(UserResponse.self, from: data)
    }
    
    // Login
    static func login(_ username: String, _ password: String) async throws -> Token {
        let url = URL(string: baseURL + "/users/login")
        
        guard let url else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        // Shape of Data: "username=sethartykun&password=12345678"
        request.httpBody = "username=\(username)&password=\(password)".data(using: .utf8)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            if let apiError = try? JSONDecoder().decode(APIErrorResponse.self, from: data) {
                throw APIError.server(apiError.detail)
            }
            throw APIError.unknown
        }
        
        return try JSONDecoder().decode(Token.self, from: data)
    }
    
    static func loginWithGoogle(_ idToken: String) async throws -> Token {
        let url = URL(string: baseURL + "/users/google-login")
        guard let url else { throw URLError(.badURL) }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(["id_token": idToken])
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            if let apiError = try? JSONDecoder().decode(APIErrorResponse.self, from: data) {
                throw APIError.server(apiError.detail)
            }
            throw APIError.unknown
        }
        
        return try JSONDecoder().decode(Token.self, from: data)
    }
    
    // Fetch current user
    static func fetchCurrentUser(_ token: String) async throws -> UserResponse {
        let url = URL(string: baseURL + "/users/me")
        
        guard let url else { throw URLError(.badURL) }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            if let apiError = try? JSONDecoder().decode(APIErrorResponse.self, from: data) {
                throw APIError.server(apiError.detail)
            }
            
            throw APIError.unknown
        }
        
        return try JSONDecoder().decode(UserResponse.self, from: data)
    }
    
    // Fetch note by ID
    static func fetchNote(_ id: Int, _ token: String) async throws -> NoteResponse {
        let url = URL(string: baseURL + "/notes/\(id)")
        
        guard let url else { throw URLError(.badURL) }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            if let apiError = try? JSONDecoder().decode(APIErrorResponse.self, from: data) {
                throw APIError.server(apiError.detail)
            }
            
            throw APIError.unknown
        }
        
        return try JSONDecoder().decode(NoteResponse.self, from: data)
    }
    
    // Fetch notes
    static func fetchNotes(_ token: String, _ limit: Int = 10, _ offset: Int = 0) async throws -> NoteListResponse {
        
        let url = URL(string: baseURL + "/notes/?limit=\(limit)&offset=\(offset)")
        
        guard let url else { throw URLError(.badURL) }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            if let apiError = try? JSONDecoder().decode(APIErrorResponse.self, from: data) {
                throw APIError.server(apiError.detail)
            }
            
            throw APIError.unknown
        }
        
        return try JSONDecoder().decode(NoteListResponse.self, from: data)
    }
    
    // Create note
    static func createNote(_ token: String, _ note: NoteCreate) async throws -> NoteResponse {
        let url = URL(string: baseURL + "/notes/")
        
        guard let url else { throw URLError(.badURL) }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpBody = try JSONEncoder().encode(note)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            if let apiError = try? JSONDecoder().decode(APIErrorResponse.self, from: data) {
                throw APIError.server(apiError.detail)
            }
            
            throw APIError.unknown
        }
        
        return try JSONDecoder().decode(NoteResponse.self, from: data)
    }
    
    // Update Note
    // PATCH semantics: every field here MUST be Optional (String?, Bool?, etc).
    // Reason: Swift's auto-generated Codable encoder uses `encodeIfPresent` for
    // Optional properties, which OMITS the key entirely from the JSON when the
    // value is nil (it does NOT send "key": null).
    //
    // This matters because FastAPI's model_dump(exclude_unset=True) only looks
    // at which keys were actually present in the request body. A field that's
    // nil here never shows up as a key at all, so the server treats it as
    // "untouched" and leaves that column in the database exactly as it was.
    //
    // nil = "I have nothing to say about this field" (leave it alone)
    // NOT   "set this field to empty" (that would need an explicit null, which
    //        this app doesn't send)
    
    
    // Example, using a stand-in type just to see the shape:
    //
    //   struct TaskPatch: Codable {
    //       var title: String?
    //       var isDone: Bool?
    //   }
    //
    //   let patch = TaskPatch(title: nil, isDone: true)
    //   // Encoding `patch` produces:  {"isDone": true}
    //   // NOT:                        {"title": null, "isDone": true}
    //
    // Because `title` was nil, encodeIfPresent skipped the key entirely.
    // On the server, that means "title" never appears in the request body,
    // so exclude_unset=True treats title as "not sent" — the note keeps
    // whatever title it already had. Only isDone gets updated.
    static func updateNote(_ id: Int, _ token: String, _ note: NoteUpdate) async throws -> NoteResponse{
        let url = URL(string: baseURL + "/notes/\(id)")
        
        guard let url else { throw URLError(.badURL) }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpBody = try JSONEncoder().encode(note)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            if let apiError = try? JSONDecoder().decode(APIErrorResponse.self, from: data) {
                throw APIError.server(apiError.detail)
            }
            
            throw APIError.unknown
        }
        
        return try JSONDecoder().decode(NoteResponse.self, from: data)
    }
    
    
    static func deleteNote(_ token: String, _ id: Int) async throws {
        let url = URL(string: baseURL + "/notes/\(id)")
        
        guard let url else { throw URLError(.badURL) }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            if let apiError = try? JSONDecoder().decode(APIErrorResponse.self, from: data) {
                throw APIError.server(apiError.detail)
            }
            
            throw APIError.unknown
        }
    }
    
}

