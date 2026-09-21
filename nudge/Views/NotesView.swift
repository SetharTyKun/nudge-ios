//
//  NotesView.swift
//  NotesApp
//
//  Created by Sethar TyKun on 20/8/26.
//

import SwiftUI

struct NotesView: View {
    @Environment(NotesViewModel.self) private var notesViewModel
    @Environment(AuthViewModel.self) private var authViewModel
    
    @State private var showDeleteConfirmation = false
    @State private var noteToDelete: NoteResponse?
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                
                switch notesViewModel.state {
                    
                case .idle, .loading:
                    Spacer()
                    ProgressView()
                    Spacer()
                    
                case .loaded(let notes):
                    
                    if notes.isEmpty {
                        Spacer()
                        Text("Empty")
                            .foregroundStyle(.secondary)
                        Spacer()
                    } else {
                        List {
                            
                            // PINNED NOTES
                            Section {
                                if pinnedNotes.isEmpty {
                                    EmptyView()
                                } else {
                                    ForEach(pinnedNotes) { note in
                                        let result = getTitleAndContent(note.content)
                                        
                                        VStack(alignment: .leading) {
                                            Text(result.title)
                                                .font(.system(size: 16, weight: .bold))
                                            
                                            Spacer()
                                                .frame(height: 8)
                                            
                                            HStack {
                                                Text(result.content.isEmpty ? "No content" : result.content)
                                                    .font(.system(size: 14))
                                                    .lineLimit(1)
                                                
                                                Spacer()
                                                
                                                Spacer()
                                                    .frame(width: 16)
                                                
                                                Text(stringToDate(note.createdAt))
                                                    .font(.system(size: 14))
                                            }
                                        }
                                        .background {
                                            NavigationLink {
                                                NoteDetailView(note: note, title: result.title, content: result.content)
                                            } label: {
                                                EmptyView()
                                            }
                                            .opacity(0)
                                        }
                                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                            // Delete Button
                                            Button(role: .destructive) {
                                                noteToDelete = note
                                                showDeleteConfirmation = true
                                            } label: {
                                                Label("Delete", systemImage: "trash")
                                            }
                                            
                                            // Complete Button
                                            Button {
                                                if case .loaded(var currentNotes) = notesViewModel.state,
                                                    let index = currentNotes.firstIndex(where: { $0.id == note.id }) {
                                                        currentNotes[index].isCompleted.toggle()
                                                        notesViewModel.state = .loaded(currentNotes)
                                                    }

                                                    let update = NoteUpdate(isCompleted: !note.isCompleted)

                                                    Task {
                                                        try? await notesViewModel.updateNote(note.id, note: update)
                                                    }
                                            } label: {
                                                Label("Complete", systemImage: "checkmark")
                                            }
                                            .tint(.green)
                                            

                                            // Pin Button
                                            Button {
                                                togglePin(for: note)
                                            } label: {
                                                Label(note.isPinned ? "Unpin" : "Pin", systemImage: note.isPinned ? "pin.slash" : "pin")
                                            }
                                            .tint(.orange)
                                        }
                                    }
                                }
                                
                            } header: {
                                if pinnedNotes.isEmpty {
                                    EmptyView()
                                } else {
                                    HStack {
                                        Image(systemName: "pin")
                                        Text("Pinned")
                                        Spacer()
                                    }
                                }
                            }
                            
                            // UNPINNED NOTES
                            Section {
                                if unPinnedNotes.isEmpty {
                                    EmptyView()
                                } else {
                                    ForEach(unPinnedNotes) { note in
                                        let result = getTitleAndContent(note.content)
                                        
                                        VStack(alignment: .leading) {
                                            Text(result.title)
                                                .font(.system(size: 16, weight: .bold))
                                            
                                            Spacer()
                                                .frame(height: 8)
                                            
                                            HStack {
                                                Text(result.content.isEmpty ? "No content" : result.content)
                                                    .font(.system(size: 14))
                                                    .lineLimit(1)
                                                
                                                Spacer()
                                                
                                                Spacer()
                                                    .frame(width: 16)
                                                
                                                Text(stringToDate(note.createdAt))
                                                    .font(.system(size: 14))
                                            }
                                        }
                                        .background {
                                            NavigationLink {
                                                NoteDetailView(note: note, title: result.title, content: result.content)
                                            } label: {
                                                EmptyView()
                                            }
                                            .opacity(0)
                                        }
                                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                            Button(role: .destructive) {
                                                noteToDelete = note
                                                showDeleteConfirmation = true
                                            } label: {
                                                Label("Delete", systemImage: "trash")
                                            }
                                            
                                            Button {
                                                if case .loaded(var currentNotes) = notesViewModel.state,
                                                       let index = currentNotes.firstIndex(where: { $0.id == note.id }) {
                                                        currentNotes[index].isCompleted.toggle()
                                                        notesViewModel.state = .loaded(currentNotes)
                                                    }

                                                    let update = NoteUpdate(isCompleted: !note.isCompleted)

                                                    Task {
                                                        try? await notesViewModel.updateNote(note.id, note: update)
                                                    }
                                            } label: {
                                                Label("Complete", systemImage: "checkmark")
                                            }
                                            .tint(.green)
                                            
                                            Button {
                                                togglePin(for: note)
                                            } label: {
                                                Label(note.isPinned ? "Unpin" : "Pin", systemImage: note.isPinned ? "pin.slash" : "pin")
                                            }
                                            .tint(.orange)
                                        }
                                    }
                                }
                                
                            } header: {
                                if unPinnedNotes.isEmpty {
                                    EmptyView()
                                } else {
                                    HStack {
                                        Text("Notes")
                                        Spacer()
                                    }
                                }
                            }
                            
                            // COMPLETED NOTES
                            Section {
                                if completedNotes.isEmpty {
                                    EmptyView()
                                } else {
                                    ForEach(completedNotes) { note in
                                        let result = getTitleAndContent(note.content)
                                        
                                        VStack(alignment: .leading) {
                                            Text(result.title)
                                                .font(.system(size: 16, weight: .bold))
                                            
                                            Spacer()
                                                .frame(height: 8)
                                            
                                            HStack {
                                                Text(result.content.isEmpty ? "No content" : result.content)
                                                    .font(.system(size: 14))
                                                    .lineLimit(1)
                                                
                                                Spacer()
                                                
                                                Spacer()
                                                    .frame(width: 16)
                                                
                                                Text(stringToDate(note.createdAt))
                                                    .font(.system(size: 14))
                                            }
                                        }
                                    }
                                }
                                
                            } header: {
                                if completedNotes.isEmpty {
                                    EmptyView()
                                } else {
                                    HStack {
                                        Text("Completed")
                                        Spacer()
                                    }
                                }
                            }
                            

                        }
                        .alert("Delete this note?", isPresented: $showDeleteConfirmation) {
                            Button("Cancel", role: .cancel) { }
                            Button("Delete", role: .destructive) {
                                guard let noteToDelete else { return }

                                if case .loaded(var currentNotes) = notesViewModel.state {
                                    currentNotes.removeAll { $0.id == noteToDelete.id }
                                    notesViewModel.state = .loaded(currentNotes)
                                }
                                
                                Task {
                                    try? await notesViewModel.deleteNote(noteToDelete.id)
                                }
                            }
                        } message: {
                            Text("This action cannot be undone.")
                        }
                    }
                    
                case .failed(let error):
                    Spacer()
                    VStack {
                        Text("Something went wrong")
                            .font(.headline)
                        Text(error.localizedDescription)
                            .foregroundStyle(.secondary)
                            .font(.subheadline)
                        Spacer().frame(height: 10)
                        Button("Retry") {
                            Task {
                                do {
                                    notesViewModel.state = .loading
                                    try await notesViewModel.getNotes()
                                } catch {
                                    notesViewModel.state = .failed(error)
                                }
                            }
                        }
                        .buttonStyle(.glass)
                    }
                    .padding()
                    Spacer()
                }
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .navigationTitle("Notes")
            .toolbar {
                ToolbarItem {
                    NavigationLink {
                        NoteCreateView(notesViewModel: notesViewModel)
                    } label: {
                        Image(systemName: "plus")
                    }
                    .tint(.white)
                }
            }
        }
    }
    
    // Properties & Methods
    let isoFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(identifier: "UTC")
        return formatter
    }()
    
    private var completedNotes: [NoteResponse] {
        guard case .loaded(let notes) = notesViewModel.state else { return [] }
        
        return notes
            .filter { note in
                note.isCompleted == true
            }
    }
    
    private var pinnedNotes: [NoteResponse] {

        guard case .loaded(let notes) = notesViewModel.state else { return [] }
        
        return notes.filter { note in
            note.isPinned == true && note.isCompleted == false
        }.sorted { note1, note2 in
            let date1 = isoFormatter.date(from: note1.createdAt) ?? .distantPast
            let date2 = isoFormatter.date(from: note2.createdAt) ?? .distantPast
            return date1 > date2
        }
    }
    
    private var unPinnedNotes: [NoteResponse] {
        guard case .loaded(let notes) = notesViewModel.state else { return [] }
        
        return notes.filter { note in
            note.isPinned == false && note.isCompleted == false
        }.sorted { note1, note2 in
            let date1 = isoFormatter.date(from: note1.createdAt) ?? .distantPast
            let date2 = isoFormatter.date(from: note2.createdAt) ?? .distantPast
            return date1 > date2
        }
    }
    
    func stringToDate(_ dateString: String) -> String {
        let date = isoFormatter.date(from: dateString)
        
        guard let date else {
            return "Unknown date"
        }
        
        if Calendar.current.isDateInToday(date) {
            return date.formatted(.dateTime.hour().minute())
        } else {
            return date.formatted(.dateTime.month(.abbreviated).day())
        }
    }

    
    private func togglePin(for note: NoteResponse) {
        if case .loaded(var currentNotes) = notesViewModel.state,
           let index = currentNotes.firstIndex(where: { $0.id == note.id }) {
            currentNotes[index].isPinned.toggle()
            notesViewModel.state = .loaded(currentNotes)
        }

        let update = NoteUpdate(isPinned: !note.isPinned)
        Task {
            try? await notesViewModel.updateNote(note.id, note: update)
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
    NotesView()
        .preferredColorScheme(.dark)
        .environment(NotesViewModel(auth: AuthViewModel()))
}



