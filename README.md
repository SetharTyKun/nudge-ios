# Nudge

*Some thoughts only knock once. Nudge makes sure you're there to answer.*

Nudge is a notes-taking iOS app built with SwiftUI, featuring secure authentication, biometric-protected notes, real-time note management, and a clean, distraction-free interface. This repository contains the iOS client; the companion FastAPI backend lives in a separate repo (linked below).

## Features

- Email/username + password authentication with JWT-based sessions
- Sign in with Google (OAuth 2.0)
- Face ID / Touch ID-protected session token, backed by Keychain access control
- Create, edit, pin, and delete notes
- Smart timestamps — shows the time for notes created today, and the date for anything older
- Dark-themed, minimal UI

## Tech Stack

- **SwiftUI** for the interface
- **MVVM architecture** with `@Observable` view models
- **Swift Concurrency** (`async`/`await`) for networking
- **URLSession** for API communication
- **GoogleSignIn-iOS SDK** for OAuth
- **JWT** bearer token authentication, persisted via Keychain
- **Security** + **LocalAuthentication** frameworks for biometric-gated secure storage

## Backend

Nudge talks to a FastAPI backend, hosted separately: [nudge-backend](https://github.com/yourusername/nudge-backend)

- FastAPI + SQLModel
- JWT authentication with `python-jose` and `bcrypt` password hashing
- Deployed on Railway

## Getting Started

1. Clone the repository
2. Open `nudge.xcodeproj` in Xcode
3. Copy `Configs/Secrets.xcconfig.example` to `Configs/Secrets.xcconfig` and fill in your own values:
   - `API_BASE_URL` — your backend's base URL
   - Google OAuth client ID (set up via [Google Cloud Console](https://console.cloud.google.com/) for an iOS client)
4. Build and run on a simulator or physical device
   - Note: Face ID/Touch ID protection on the session token relies on `SecItemCopyMatching` with Keychain access control, which is unreliable in the iOS Simulator — test on a physical device for accurate behavior.

## Architecture

Nudge follows the MVVM pattern:

- **Models** — Codable structs matching the backend's API schemas
- **ViewModels** — `AuthViewModel` and `NotesViewModel`, shared across the app via SwiftUI's environment
- **Views** — SwiftUI screens for sign in, sign up, notes list, note creation/editing, and profile
- **Services** —
  - `NoteAPI` — handles all networking, using `async`/`await` and `URLSession`
  - `Keychain` — lightweight wrapper for storing/retrieving general Keychain values
  - `SecureVault` — Face ID / Touch ID-gated storage specifically for the session token, using Keychain access control (`kSecAttrAccessControl`)

## Security Notes

- Secrets (API base URL, OAuth client ID) are kept out of version control via `Configs/Secrets.xcconfig`, which is gitignored. See `Configs/Secrets.xcconfig.example` for the expected format.
- The session/access token is stored in Keychain behind Face ID / Touch ID authentication via `SecureVault`, rather than in `UserDefaults` or plain Keychain.
- Note content itself is not additionally biometric-gated — access follows from the authenticated session.
