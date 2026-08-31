//
//  TestView.swift
//  NotesApp
//
//  Created by Sethar TyKun on 28/8/26.
//

import SwiftUI

struct TestView: View {
    @State private var fullText: String = ""
    
    var body: some View {
        VStack {
            VStack {
                TextEditor(text: $fullText)
                
                
                Button {
                    let result = getTitleAndContent(fullText)
                    print(result.title)
                    print(result.content)
                } label: {
                    Text("See")
                }
            }
            .padding()
        }
        .frame(width: .infinity, height: .infinity, alignment: .top)
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
    TestView()
        .preferredColorScheme(.dark)
}
