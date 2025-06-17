//
//  AuthService.swift
//  SoonToBeNamed
//
//  Created by Darrell Cornelius Rivaldo on 13/06/25.
//

import Supabase
import AuthenticationServices
import Foundation

@MainActor
final class AuthService: ObservableObject {
    @Published var session: Session?
    @Published var role: Role?
    @Published var isAuthenticated = false
    @Published var isLoading = true
    var user: User? {
        return session?.user
    }
    
    func loadSession() async {
        do {
            let supabaseSession = try await supabase.auth.session
            self.session = supabaseSession
            self.isAuthenticated = self.session != nil
        } catch {
            print("Error loading session: \(error)")
        }
    }
    
    func signInWithApple(result: Result<ASAuthorization, any Error>) async throws {
        guard let credential = try result.get().credential as? ASAuthorizationAppleIDCredential
        else {
            return
        }
        
        guard let idToken = credential.identityToken
            .flatMap({ String(data: $0, encoding: .utf8) })
        else {
            return
        }
        
        let session = try await supabase.auth.signInWithIdToken(
            credentials: .init(
                provider: .apple,
                idToken: idToken
            )
        )
        
        if let name = credential.fullName {
            let fullName = "\(name.givenName ?? "") \(name.familyName ?? "")"
            try await supabase.auth.update(
                user: UserAttributes(
                    data: [
                        "display_name": AnyJSON.string(fullName)
                    ]
                )
            )
        }
        
        self.session = session
        self.isAuthenticated = true
    }
    
    func signInWithEmail(email: String, password: String) async throws {
        let session = try await supabase.auth.signIn(
            email: email,
            password: password
        )
        self.session = session
        self.isAuthenticated = true
    }
    
    func logout() async throws {
        try await supabase.auth.signOut()
        self.session = nil
        self.isAuthenticated = false
        self.role = nil
    }
}
