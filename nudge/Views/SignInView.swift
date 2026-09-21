//
//  SignInView.swift
//  NotesApp
//
//  Created by Sethar TyKun on 19/8/26.
//

import SwiftUI
import GoogleSignIn

struct SignInView: View {
    @Environment(AuthViewModel.self) private var authViewModel
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var errorMessage: String?
    @State private var seePassword = false
    @State private var showError = false
    @State private var showSignUp = false
    @FocusState private var focusedField: Field?
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                
                Spacer()
                
                Text("Welcome to Nudge")
                    .foregroundStyle(.primary)
                    .font(.largeTitle.bold())
                    .frame(maxWidth: .infinity, alignment: .center)
                
                Spacer()
                    .frame(height: 16)
                
                Text("Some thoughts only knock once. Nudge makes")
                    .frame(maxWidth: .infinity, alignment: .center)
                    .foregroundStyle(.primary)
                    .font(.subheadline)
                Text("sure you're there to answer.")
                    .frame(maxWidth: .infinity, alignment: .center)
                    .foregroundStyle(.primary)
                    .font(.subheadline)
                
                Spacer()
                    .frame(height: 48)
                
                Text("Username".uppercased())
                    .foregroundStyle(.secondary)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                Spacer()
                    .frame(height: 8)
                
                TextField("Username or email", text: $username)
                    .frame(height: 30)
                    .textInputAutocapitalization(.never)
                    .padding(10)
                    .background(Color(uiColor: .secondarySystemGroupedBackground))
                    .cornerRadius(16)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color(red: 0.17, green: 0.17, blue: 0.22), lineWidth: 1)
                    )
                    .foregroundColor(.white)
                    .tint(.white)
                    .focused($focusedField, equals: .username)
                
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

            
                Button {
                    Task {
                        do {
                            try validateSignIn(username, password)
                            try await authViewModel.login(username, password)
                            username = ""
                            password = ""
                        } catch {
                            errorMessage = error.localizedDescription
                            showError = true
                        }
                    }
                } label: {
                    Text("Sign In")
                        .foregroundStyle(.black)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(12)
                .background(.white)
                .cornerRadius(32)
                .alert("Something went wrong", isPresented: $showError) {
                    Button("Retry", role: .cancel) { }
                } message: {
                    if let errorMessage { Text(errorMessage) }
                }
                
                
                Spacer()
                    .frame(height: 16)
                
                HStack {
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(.gray)
                        
                    Text("or")
                        .foregroundColor(.gray)
                        .font(.caption)

                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                    .frame(height: 16)
                
                Button {
                    signInWithGoogle()
                } label: {
                    HStack {
                        Spacer()
                        Image("GoogleIcon")
                            .resizable()
                            .frame(width: 25, height: 25)
                        Spacer()
                            .frame(width: 16)
                        Text("Continue with Google")
                            .foregroundStyle(.black)
                        Spacer()
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(12)
                .background(.white)
                .cornerRadius(32)
                .alert("Something went wrong", isPresented: $showError) {
                    Button("Retry", role: .cancel) { }
                } message: {
                    if let errorMessage { Text(errorMessage) }
                }
                
                
                Spacer()
                    .frame(height: 16)
                
                HStack {
                    Text("Don't have an account?")
                        .foregroundStyle(.primary)
                        .font(.subheadline)
                    Button("Sign Up") {
                        username = ""
                        password = ""
                        seePassword = false
                        showSignUp = true
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)
                
            }
            .padding()
            .navigationDestination(isPresented: $showSignUp) {
                SignUpView()
            }
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
    
    
    private func signInWithGoogle() {
        guard let rootViewController = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first?.windows.first?.rootViewController else {
            return
        }
        
        GIDSignIn.sharedInstance.configuration = GIDConfiguration(clientID: Config.googleClientID)
        
        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { result, error in
            if let error = error {
                print("Google Sign-In error: \(error.localizedDescription)")
                return
            }
            
            guard let idToken = result?.user.idToken?.tokenString else {
                return
            }
            
            Task { @MainActor in
                do {
                    try await authViewModel.loginWithGoogle(idToken)
                } catch {
                    errorMessage = error.localizedDescription
                    showError = true
                }
            }
        }
    }
}

private enum Field {
    case username
    case password
}



#Preview {
    SignInView()
        .preferredColorScheme(.dark)
        .environment(AuthViewModel())
}


