//
//  ProfileView.swift
//  NotesApp
//
//  Created by Sethar TyKun on 20/8/26.
//

import SwiftUI

struct ProfileView: View {
    @Environment(AuthViewModel.self) private var authViewModel
    @Environment(NotesViewModel.self) private var notesViewModel
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .center) {
                    
                    Text(authViewModel.currentUser?.username.first?.uppercased() ?? "P")
                        .frame(width: 80, height: 80)
                        .font(.system(size: 28, weight: .bold))
                        .glassEffect()
                        .clipShape(.circle)
                    
                    Spacer()
                        .frame(height: 16)
                    
                    Text(authViewModel.currentUser?.username.lowercased() ?? "Unknown")
                        .font(.system(size: 18, weight: .bold))
                    
                    Spacer()
                        .frame(height: 8)
                    
                    Text(verbatim: authViewModel.currentUser?.email.lowercased() ?? "N/A")
                        .foregroundStyle(.secondary)
                        .font(.system(size: 16, weight: .semibold))
                    
                    Spacer()
                        .frame(height: 32)
                    
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            
            }
            .navigationTitle("Profile")
            .toolbar {
                ToolbarItem {
                    Button {
                        authViewModel.logout()
                        notesViewModel.resetState()
                    } label: {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                            .font(.system(size: 14))
                    }
                    .tint(.red)
                }
            }
        }
    }
    
    // Properties & Methods
    private var totalNotes: [NoteResponse] {
        guard case .loaded(let notes) = notesViewModel.state else { return [] }
        
        return notes.filter { note in
            note.isCompleted == false
        }
    }
    
    private var pinnedNotes: [NoteResponse] {
        guard case .loaded(let notes) = notesViewModel.state else { return [] }
        
        return notes
            .filter { note in
                note.isPinned == true && note.isCompleted == false
            }
    }
    
    private var completedNotes: [NoteResponse] {
        guard case .loaded(let notes) = notesViewModel.state else { return [] }
        
        return notes.filter { note in
            note.isCompleted == true
        }
    }
}

#Preview {
    ProfileView()
        .preferredColorScheme(.dark)
        .environment(AuthViewModel())
        .environment(NotesViewModel(auth: AuthViewModel()))
}
