//
//  NoteCreateView.swift
//  NotesApp
//
//  Created by Sethar TyKun on 22/8/26.
//

import SwiftUI

struct NoteCreateView: View {
    @State var notesViewModel: NotesViewModel
    
    @Environment(\.dismiss) private var dismiss
    @State private var fullText = ""
    @State private var errorMessage: String?
    @State private var showError = false
    @State private var isLoading = false
    @FocusState private var isEditorFocused: Bool
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading) {
                    
                    TextEditor(text: $fullText)
                        .focused($isEditorFocused)
 
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .ignoresSafeArea(.keyboard, edges: .bottom)
                .toolbar {
                    ToolbarItem {
                        Button {
                            
                            guard !fullText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                                dismiss()
                                return
                            }

                            let noteCreate = NoteCreate(content: fullText)
                            
                            Task {
                                defer { isLoading = false }
                                do {
                                    isLoading = true
                                    try await notesViewModel.createNote(noteCreate)
                                    try await notesViewModel.getNotes()
                                    dismiss()
                                } catch {
                                    errorMessage = error.localizedDescription
                                    showError = true
                                }
                            }
                            
                        } label: {
                            if isLoading { ProgressView() } else { Image(systemName: "checkmark") }
                        }
                        .alert("Something went wrong", isPresented: $showError) {
                            Button("OK", role: .cancel) { }
                        } message: {
                            if let errorMessage { Text(errorMessage) }
                        }
                    }
                    
                    ToolbarItemGroup(placement: .keyboard) {
                        Spacer()
                        Button {
                            isEditorFocused = false
                        } label: {
                            Image(systemName: "chevron.down")
                        }
                    }
                }
            }
        }
        .task {
            isEditorFocused = true
        }
    }
    
    func getTitleAndContent(_ fullText: String) -> (title: String, content: String) {
        // ..< means "up to, but not including."
        // ... means "up to, and including."
        let trimmed = fullText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if let newLineIndex = trimmed.firstIndex(of: "\n") {
            var title = String(trimmed[..<newLineIndex])
            var content = String(trimmed[fullText.index(after: newLineIndex)...])
            
            title = title.trimmingCharacters(in: .whitespacesAndNewlines)
            content = content.trimmingCharacters(in: .whitespacesAndNewlines)
            
            return (title, content)
        }
        
        return (trimmed, "")
    }
}

#Preview {
    NoteCreateView(notesViewModel: NotesViewModel(auth: AuthViewModel()))
        .preferredColorScheme(.dark)
}
