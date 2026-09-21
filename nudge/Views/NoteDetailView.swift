//
//  NoteDetailView.swift
//  NotesApp
//
//  Created by Sethar TyKun on 22/8/26.
//

import SwiftUI

struct NoteDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(NotesViewModel.self) private var notesViewModel
    
    let note: NoteResponse
    
    @State private var fullText: String
    @State private var errorMessage: String?
    @State private var showError = false
    @State private var isLoading = false
    @FocusState private var isEditorFocused: Bool
    
    init(note: NoteResponse, title: String, content: String) {
        self.note = note
        _fullText = State(initialValue: "\(title)\n\(content)")
    }
    
    var body: some View {
        NavigationStack {
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
                        
                        
                        if note.content == fullText {
                            dismiss()
                            return
                        }

                        let updatedNote = NoteUpdate(content: fullText)
                        
                        Task {
                            defer { isLoading = false }
                            do {
                                isLoading = true
                                try await notesViewModel.updateNote(note.id, note: updatedNote)
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

private enum Field {
    case title
    case content
}


#Preview {
    NoteDetailView(
        note: NoteResponse(
            id: 1,
            content: "Milk, eggs, bread, coffee",
            isPinned: true,
            isCompleted: false,
            ownerId: 1,
            createdAt: "2026-08-15T09:00:00Z",
            updatedAt: "2026-08-15T09:00:00Z"
        ),
        title: "How to love yourself",
        content: "Chupapi",
    )
    .preferredColorScheme(.dark)
    .environment(NotesViewModel(auth: AuthViewModel()))
}


//                    TextField("Title", text: $editableTitle, axis: .vertical)
//                        .lineLimit(3)
//                        .font(.system(size: 32, weight: .bold))
//                        .focused($focusedField, equals: .title)
//
//
//                    Spacer()
//                        .frame(height: 16)
//
//
//                    ZStack(alignment: .topLeading) {
//                        if editableContent.isEmpty {
//                            Text("Write your note...")
//                                .foregroundStyle(.secondary)
//                                .padding(.horizontal, 4)
//                                .padding(.vertical, 8)
//                                .allowsHitTesting(false)
//                        }
//
//                        TextEditor(text: $editableContent)
//                            .scrollContentBackground(.hidden)
//                            .scrollDisabled(true)
//                            .focused($focusedField, equals: .content)
//                    }
