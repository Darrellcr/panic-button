//
//  ContentView.swift
//  SoonToBeNamed
//
//  Created by Darrell Cornelius Rivaldo on 12/06/25.
//

import SwiftUI
import AuthenticationServices
import Supabase

struct AuthView: View {
    @State var email: String = ""
    @State var password: String = ""
    
    let authService = AuthService()
    let notificationService = NotificationService()
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
            TextField("asd", text: $email)
                .textInputAutocapitalization(.never)
            SecureField("ewq", text: $password)
            
            Button("Login") {
                Task {
                    do {
                        let session = try await authService.signInWithEmail(email: email, password: password)
                    } catch {
                        dump(error)
                    }
                }
            }
            .buttonStyle(.bordered)
            
            Divider()
                .padding(.bottom, 32)
            
            
            SignInWithAppleButton { request in
                request.requestedScopes = [.email, .fullName]
            } onCompletion: { result in
                Task {
                    do {
                        let session = try await authService.signInWithApple(result: result)!
                    } catch {
                        dump(error)
                    }
                }
            }
            .frame(maxHeight: 50)
            .padding(.horizontal)
        }
        .padding()
    }
}

#Preview {
    AuthView()
}
