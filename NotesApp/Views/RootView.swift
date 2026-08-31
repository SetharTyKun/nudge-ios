//
//  RootView.swift
//  NotesApp
//
//  Created by Sethar TyKun on 19/8/26.
//

import SwiftUI

struct RootView: View {
    @Environment(AuthViewModel.self) private var authViewModel
    @Environment(NotesViewModel.self) private var notesViewModel
    
    var body: some View {
        VStack {
            if(authViewModel.isLoggedIn == false) {
                SignInView()
            } else {
                TabView {
                    Tab("Home", systemImage: "house"){
                        HomeView()
                    }
                    Tab("Notes", systemImage: "list.bullet.clipboard"){
                        NotesView()
                    }
                    Tab("Profile", systemImage: "person.crop.circle"){
                        ProfileView()
                    }
                }
            }
        }
        .task(id: authViewModel.isLoggedIn) {
            guard authViewModel.isLoggedIn else { return }
            
            if case .idle = notesViewModel.state {
                do {
                    try await authViewModel.fetchCurrentUser()
                    try await notesViewModel.getNotes()
                } catch {
                    notesViewModel.state = .failed(error)
                }
            }
        }
    }
}

#Preview {
    RootView()
        .environment(AuthViewModel())
        .environment(NotesViewModel(auth: AuthViewModel()))
        .preferredColorScheme(.dark)
}
