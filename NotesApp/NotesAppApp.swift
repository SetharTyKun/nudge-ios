//
//  NotesAppApp.swift
//  NotesApp
//
//  Created by Sethar TyKun on 17/8/26.
//

import SwiftUI
import GoogleSignIn

@main
struct NotesAppApp: App {
    @State private var authViewModel: AuthViewModel
    @State private var notesViewModel: NotesViewModel
    
    init() {
        let auth = AuthViewModel()
        _authViewModel = State(initialValue: auth)
        _notesViewModel = State(initialValue: NotesViewModel(auth: auth))
    }
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(authViewModel)
                .environment(notesViewModel)
                .onOpenURL { url in
                    GIDSignIn.sharedInstance.handle(url)
                }
        }
    }
}
