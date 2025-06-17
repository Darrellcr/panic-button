//
//  SwiftUIView.swift
//  SoonToBeNamed
//
//  Created by Darrell Cornelius Rivaldo on 17/06/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var authService = AuthService()
    private let profileService = ProfileService()
    
    var body: some View {
        Group {
            if authService.isLoading {
                LoadingView()
            } else if !authService.isAuthenticated {
                LoginView()
            } else if authService.role == nil {
                RoleSelectionView()
            } else if authService.role == Role.guardian {
                GuardianView()
            } else if authService.role == Role.elderly {
                ElderlyView()
            } else {
                Text("Empty")
            }
        }
        .environmentObject(authService)
        .task {
            Task {
                authService.isLoading = true
                await authService.loadSession()
                if let user = authService.user {
                    let uuidString = user.id.uuidString
                    let role = await profileService.getRole(uuid: uuidString)
                    await MainActor.run {
                        authService.role = role
                    }
                }
                authService.isLoading = false
            }
        }
    }
}

#Preview {
    ContentView()
}
