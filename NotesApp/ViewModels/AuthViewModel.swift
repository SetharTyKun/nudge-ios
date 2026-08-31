//
//  AuthViewModel.swift
//  NotesApp
//
//  Created by Sethar TyKun on 17/8/26.
//
import Foundation
import Observation

@Observable
final class AuthViewModel {
    var currentUser: UserResponse?
    var token: String?
    var isLoggedIn: Bool {
        self.token != nil
    }
    
    
    init() {
        self.token = UserDefaults.standard.string(forKey: "access_token")
//        UserDefaults.standard.removeObject(forKey: "access_token")
    }
    
    func register(_ user: UserCreate) async throws -> UserResponse {
        let created = try await NoteAPI.register(user)
    
        return created
    }
    
    func login(_ username: String, _ password: String) async throws {
        let token = try await NoteAPI.login(username, password)
        
        UserDefaults.standard.set(token.accessToken, forKey: "access_token")
        self.token = token.accessToken
    }
    
    func logout() {
        UserDefaults.standard.removeObject(forKey: "access_token")
        self.token = nil
        currentUser = nil
    }
    
    func fetchCurrentUser() async throws {
        guard let unwrap = self.token else { throw URLError(.userAuthenticationRequired) }
        
        currentUser = try await NoteAPI.fetchCurrentUser(unwrap)
    }
    
}
