//
//  AuthService.swift
//  SoonToBeNamed
//
//  Created by Darrell Cornelius Rivaldo on 13/06/25.
//

import Auth
import AuthenticationServices
import Foundation

final class AuthService {
    func signInWithApple(result: Result<ASAuthorization, any Error>) async throws -> Session? {
        guard let credential = try result.get().credential as? ASAuthorizationAppleIDCredential
        else {
            return nil
        }
        
        guard let idToken = credential.identityToken
            .flatMap({ String(data: $0, encoding: .utf8) })
        else {
            return nil
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
        
        return session
    }
    
    func signInWithEmail(email: String, password: String) async throws -> Session {
         return try await supabase.auth.signIn(
            email: email,
            password: password
         )
    }
}
