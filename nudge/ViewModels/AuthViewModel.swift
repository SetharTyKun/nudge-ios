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
        if let token = SecureVault.read(for: "access_token", reason: "Authenicate to unlock") {
            self.token = String(data: token, encoding: .utf8)
        }
    }
    
    func register(_ user: UserCreate) async throws -> UserResponse {
        let created = try await NoteAPI.register(user)
    
        return created
    }
    
    func login(_ username: String, _ password: String) async throws {
        let token = try await NoteAPI.login(username, password)
        
        self.token = token.accessToken
        SecureVault.save(token.accessToken, for: "access_token")
    }
    
    func loginWithGoogle(_ idToken: String) async throws {
        let token = try await NoteAPI.loginWithGoogle(idToken)
        
        self.token = token.accessToken
        SecureVault.save(token.accessToken, for: "access_token")
    }
    
    func logout() {
        SecureVault.delete(for: "access_token")
        self.token = nil
        currentUser = nil
    }
    
    func fetchCurrentUser() async throws {
        guard let unwrap = self.token else { throw URLError(.userAuthenticationRequired) }
        
        currentUser = try await NoteAPI.fetchCurrentUser(unwrap)
    }
    
}
