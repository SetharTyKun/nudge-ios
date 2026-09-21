//
//  TestView.swift
//  NotesApp
//
//  Created by Sethar TyKun on 28/8/26.
//

import SwiftUI

struct TestView: View {
    @State private var text: String = ""
    @State private var isLocked: Bool = false
    @State private var note: String = ""
    @State private var errorMessage: String?
    
    var body: some View {
        VStack {
            if isLocked == false {
                if !note.isEmpty {
                    Text(note)
                        .foregroundStyle(.blue)
                        .font(.largeTitle.bold())
                }
                
                Spacer()
                
                TextField("Enter your key", text: $text)
                
                HStack {
                    Button("Save") {
                        let value = text
                        SecureVault.save(value, for: "note")
                        text = ""
                        isLocked = true
                    }
                    .buttonStyle(.borderedProminent)
                    Button("Read") {
                        if let data = SecureVault.read(for: "note", reason: "Unlock to view your note") {
                            if let decoded = String(data: data, encoding: .utf8) {
                                note = decoded
                                isLocked = false
                                errorMessage = nil
                            } else {
                                errorMessage = "Couldn't unlock — try again"
                            }
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    if let errorMessage {
                        Text(errorMessage)
                            .foregroundStyle(.red)
                            .font(.caption)
                    }
                }
                
                Spacer()
            } else {
                Spacer()
                Button("Unlock") {
                    if let data = SecureVault.read(for: "note", reason: "Unlock to view your note") {
                        if let decoded = String(data: data, encoding: .utf8) {
                            note = decoded
                            isLocked = false
                            errorMessage = nil
                        } else {
                            errorMessage = "Couldn't unlock — try again"
                        }
                    }
                }
                .buttonStyle(.borderedProminent)
                if let errorMessage {
                    Text(errorMessage)
                        .foregroundStyle(.red)
                        .font(.caption)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
}

#Preview {
    TestView()
        .preferredColorScheme(.dark)
}
