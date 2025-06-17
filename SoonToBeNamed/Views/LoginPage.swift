//
//  LoginPage.swift
//  SoonToBeNamed
//
//  Created by Calvin Christian Tjong on 17/06/25.
//
import SwiftUI
import AuthenticationServices

struct LoginPage: View {
    var body: some View {
        ZStack{
            LoginBackground()
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
    LoginPage()
}
