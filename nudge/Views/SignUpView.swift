//
//  SignUpView.swift
//  NotesApp
//
//  Created by Sethar TyKun on 19/8/26.
//

import SwiftUI

struct SignUpView: View {
    @Environment(AuthViewModel.self) private var auth
    @Environment(\.dismiss) private var dismiss
    @State private var username = ""
    @State private var email = ""
    @State private var password = ""
    @State private var verifiedPassword = ""
    @State private var errorMessage: String?
    @State private var showError = false
    @State private var seePassword = false
    @State private var seeVerifiedPassword = false
    @FocusState private var focusedField: Field?
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                
                Text("Username".uppercased())
                    .foregroundStyle(.secondary)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                Spacer()
                    .frame(height: 8)
                
                TextField("Username", text: $username)
                    .frame(height: 30)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .keyboardType(.emailAddress)
                    .padding(10)
                    .background(Color(uiColor: .secondarySystemGroupedBackground))
                    .cornerRadius(16)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color(red: 0.17, green: 0.17, blue: 0.22), lineWidth: 1)
                    )
                    .focused($focusedField, equals: .username)
                
                Spacer()
                    .frame(height: 16)
                
                Text("Email".uppercased())
                    .foregroundStyle(.secondary)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                Spacer()
                    .frame(height: 8)
                
                TextField("Email", text: $email)
                    .frame(height: 30)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .keyboardType(.emailAddress)
                    .padding(10)
                    .background(Color(uiColor: .secondarySystemGroupedBackground))
                    .cornerRadius(16)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color(red: 0.17, green: 0.17, blue: 0.22), lineWidth: 1)
                    )
                    .focused($focusedField, equals: .email)
                
                Spacer()
                    .frame(height: 16)
                
                Text("Password".uppercased())
                    .foregroundStyle(.secondary)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                Spacer()
                    .frame(height: 8)
                
                Group {
                    if seePassword {
                        TextField("Password", text: $password)
                            .focused($focusedField, equals: .password)
                    } else {
                        SecureField("Password", text: $password)
                            .focused($focusedField, equals: .password)
                    }
                }
                .frame(height: 30)
                .textInputAutocapitalization(.never)
                .padding(10)
                .background(Color(uiColor: .secondarySystemGroupedBackground))
                .cornerRadius(16)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color(red: 0.17, green: 0.17, blue: 0.22), lineWidth: 1)
                )
                .foregroundStyle(.white)
                .tint(.white)
                .overlay(alignment: .trailing) {
                    Button {
                        seePassword.toggle()
                    } label: {
                        Image(systemName: seePassword ? "eye" : "eye.slash")
                            .resizable()
                            .frame(width: 20, height: 15)
                            .padding(.trailing, 16)
                            .tint(.secondary)
                    }
                }
                
                Spacer()
                    .frame(height: 16)
                
                Text("Verified Password".uppercased())
                    .foregroundStyle(.secondary)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                Spacer()
                    .frame(height: 8)
                
                Group {
                    if seeVerifiedPassword {
                        TextField("Verified Password", text: $verifiedPassword)
                            .focused($focusedField, equals: .verifiedPassword)
                    } else {
                        SecureField("Verified Password", text: $verifiedPassword)
                            .focused($focusedField, equals: .verifiedPassword)
                    }
                }
                .frame(height: 30)
                .textInputAutocapitalization(.never)
                .padding(10)
                .background(Color(uiColor: .secondarySystemGroupedBackground))
                .cornerRadius(16)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color(red: 0.17, green: 0.17, blue: 0.22), lineWidth: 1)
                )
                .foregroundStyle(.white)
                .tint(.white)
                .overlay(alignment: .trailing) {
                    Button {
                        seeVerifiedPassword.toggle()
                    } label: {
                        Image(systemName: seeVerifiedPassword ? "eye" : "eye.slash")
                            .resizable()
                            .frame(width: 20, height: 15)
                            .padding(.trailing, 16)
                            .tint(.secondary)
                    }
                }
                
                Spacer()
                
                Button {
                    
                    guard !username.isEmpty else {
                        errorMessage = "Invalid username"
                        showError = true
                        return
                    }
                    
                    guard password == verifiedPassword else {
                        errorMessage = "Unmatched password"
                        showError = true
                        return
                    }
                    
                    let user = UserCreate(username: username, email: email, password: verifiedPassword)
                    
                    Task {
                        do {
                            try validateSignUp(username, email, password, verifiedPassword)
                            let user = try await auth.register(user)
                            dismiss()
                        } catch {
                            errorMessage = error.localizedDescription
                            showError = true
                        }
                    }
                    
                    
                } label: {
                    Text("Sign Up")
                }
                .alert("Something went wrong", isPresented: $showError) {
                    Button("Retry", role: .cancel) { }
                } message: {
                    if let errorMessage { Text(errorMessage) }
                }
                .padding(12)
                .frame(maxWidth: .infinity, alignment: .center)
                .background(.white)
                .cornerRadius(32)
                .foregroundStyle(.black)
            
                
            }
            .padding()
            .navigationTitle("Sign Up")
            .ignoresSafeArea(.keyboard, edges: .bottom)
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    
                    Button {
                        focusedField = nil
                    } label: {
                        Image(systemName: "chevron.down")
                    }
                }
            }
        }
    }
}

private enum Field {
    case username
    case password
    case email
    case verifiedPassword
}

#Preview {
    SignUpView()
        .preferredColorScheme(.dark)
        .environment(AuthViewModel())
}
