//
//  HomeView.swift
//  NotesApp
//
//  Created by Sethar TyKun on 20/8/26.
//

import SwiftUI

struct HomeView: View {
    @Environment(AuthViewModel.self) private var authViewModel
    @Environment(NotesViewModel.self) private var notesViewModel
    
    var body: some View {
        NavigationStack {
            Group {
                
                switch notesViewModel.state {
                    
                case .idle, .loading:
                    ProgressView()

                case .loaded(_):
                    ScrollView {
                        VStack(alignment: .leading) {
                            
                            HStack {
                                // Left
                                VStack(alignment: .leading) {
                                    Spacer()
                                    
                                    Text("\(totalNotes.count)")
                                        .font(.system(size: 42, weight: .bold))
                                    Text("Total Notes")
                                        .font(.system(size: 16, weight: .bold))
                                }
                                .padding()
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                                .background(.pink)
                                .cornerRadius(16)
                                
                                // Right
                                VStack {
                                    VStack(alignment: .leading) {
                                        Spacer()
                                        
                                        Text("\(pinnedNotes.count)")
                                            .font(.system(size: 42, weight: .bold))
                                        Text("Pinned")
                                            .font(.system(size: 16, weight: .bold))
                                    }
                                    .padding()
                                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                                    .background(.blue)
                                    .cornerRadius(16)
                                    
                                    VStack(alignment: .leading) {
                                        Spacer()
                                        
                                        Text("\(completedNotes.count)")
                                            .font(.system(size: 42, weight: .bold))
                                        Text("Completed")
                                            .font(.system(size: 16, weight: .bold))
                                    }
                                    .padding()
                                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                                    .background(.green)
                                    .cornerRadius(16)
                                }
                                .frame(maxHeight: .infinity)
                            }
                            .frame(maxWidth: .infinity, minHeight: 350)
                            
                            
                            // First Pinned Note
                            if let note = firstPinnedNote {
                                let result = getTitleAndContent(note.content)
                                
                                Spacer()
                                    .frame(height: 32)
                                
                                Section {
                                    VStack(alignment: .leading) {
                                        Text(result.title)
                                            .foregroundStyle(.primary)
                                            .font(.headline.bold())
                                            .lineLimit(1)


                                        Text(result.content.isEmpty ? "No content" : result.content)
                                            .foregroundStyle(.secondary)
                                            .font(.body)
                                            .lineLimit(3)
                                            .lineSpacing(-1)

                                        Spacer()

                                        Text(stringToDate(note.createdAt))
                                            .font(.system(size: 14))
                                            .foregroundStyle(.secondary)
                                            .frame(maxWidth: .infinity, alignment: .trailing)
                                    }
                                    .padding()
                                    .frame(maxWidth: .infinity, minHeight: 160, alignment: .topLeading)
                                    .background(Color(uiColor: .secondarySystemGroupedBackground))
                                    .cornerRadius(16)
                                } header: {
                                    Text("Primary")
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundStyle(.secondary)
                                }
                            }
                            
                            Spacer()
                                .frame(height: 32)
                            
                            // Recent Notes
                            if !recentNotes.isEmpty {
                                Section {
                                    LazyVGrid(columns: columns, spacing: 12) {
                                        ForEach(recentNotes) { note in
                                            
                                            let result = getTitleAndContent(note.content)
                                            
                                            VStack(alignment: .leading) {
                                                Text(result.title)
                                                    .foregroundStyle(.primary)
                                                    .font(.headline.bold())
                                                    .lineLimit(1)


                                                Text(result.content.isEmpty ? "No content" : result.content)
                                                    .foregroundStyle(.secondary)
                                                    .font(.body)
                                                    .lineLimit(3)
                                                    .lineSpacing(-1)
                                                    

                                                Spacer()

                                                Text(stringToDate(note.createdAt))
                                                    .font(.system(size: 14))
                                                    .foregroundStyle(.secondary)
                                                    .frame(maxWidth: .infinity, alignment: .trailing)
                                            }
                                            .padding(12)
                                            .frame(maxWidth: .infinity, minHeight: 160, alignment: .topLeading)
                                            .background(Color(uiColor: .secondarySystemGroupedBackground))
                                            .cornerRadius(16)
                                        }
                                    }
                                    
                                } header: {
                                    Text("Recent")
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundStyle(.secondary)
                                }
                            }
                            
                            
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                        .padding()
                        
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
                    
                } // switch
                
            }
            .navigationTitle("Home")
            .toolbar {
                ToolbarItem {
                    NavigationLink {
                        ProfileView()
                    } label: {
                        Text(authViewModel.currentUser?.username.first?.uppercased() ?? "P")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.blue)
                    }
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
            .sorted { note1, note2 in
                let date1 = isoFormatter.date(from: note1.createdAt) ?? .distantPast
                let date2 = isoFormatter.date(from: note2.createdAt) ?? .distantPast
                return date1 > date2
            }
    }
    
    private var firstPinnedNote: NoteResponse? {
        pinnedNotes.first
    }
    
    private var completedNotes: [NoteResponse] {
        guard case .loaded(let notes) = notesViewModel.state else { return [] }
        
        return notes.filter { note in
            note.isCompleted == true
        }
    }
    
    private var recentNotes: [NoteResponse] {
        guard case .loaded(let notes) = notesViewModel.state else { return [] }
        
        return notes
            .filter { note in
                note.isCompleted == false
            }
            .sorted { note1, note2 in
                let date1 = isoFormatter.date(from: note1.createdAt) ?? .distantPast
                let date2 = isoFormatter.date(from: note2.createdAt) ?? .distantPast
                return date1 > date2
            }
            .prefix(4)
            .map { $0 }
    }
    
    // 2 columns
    private var columns = [
        GridItem(.flexible()), // .flexible() .fixed() .adaptive()
        GridItem(.flexible())
    ]
    
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
    HomeView()
        .environment(AuthViewModel())
        .environment(NotesViewModel(auth: AuthViewModel()))
        .preferredColorScheme(.dark)
}











