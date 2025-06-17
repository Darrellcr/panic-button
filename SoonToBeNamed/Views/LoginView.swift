//
//  LoginPage.swift
//  SoonToBeNamed
//
//  Created by Calvin Christian Tjong on 17/06/25.
//
import SwiftUI
import AuthenticationServices

struct LoginView: View {
    @EnvironmentObject var authService: AuthService
    private var profileService = ProfileService()
    
    var body: some View {
        ZStack{
            LoginBackgroundView()
            VStack{
                Image("ig")
                    .resizable()
                    .scaledToFill()
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 2))
                    .shadow(radius: 2)
                    .frame(width: 150, height: 150)
                    .padding(.bottom, 50)
                
                SignInWithAppleButton { request in
                    request.requestedScopes = [.email, .fullName]
                } onCompletion: { result in
                    Task {
                        do {
                            await MainActor.run {
                                authService.isLoading = true
                            }
                            try await authService.signInWithApple(result: result)
                            if let user = authService.user {
                                let uuidString = user.id.uuidString
                                let role = await profileService.getRole(uuid: uuidString)
                                await MainActor.run {
                                    authService.role = role
                                }
                            }
                            await MainActor.run {
                                authService.isLoading = false
                            }
                        } catch {
                            dump(error)
                        }
                    }
                }
                .frame(maxWidth: 300, maxHeight: 50)
                .padding(.horizontal)
                .signInWithAppleButtonStyle(.white)
            }
        }
    }
}

#Preview {
    LoginView()
}
