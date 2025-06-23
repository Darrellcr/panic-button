//
//  ContentView.swift
//  WatchOS Watch App
//
//  Created by Calvin Christian Tjong on 18/06/25.
//

import SwiftUI
import Supabase
import WatchConnectivity

struct ContentView: View {
    @StateObject var authService = AuthService()
    let profileService = ProfileService()
    @State var isLoading = true
    
    var body: some View {
        Group {
            if isLoading {
                LoadingView()
            } else if authService.session == nil {
                Text("Please Sign in from IPhone")
            } else if authService.role == nil {
                Text("Please choose your role from IPhone")
            } else if authService.role == Role.guardian {
                GuardianView()
            } else if authService.role == Role.elderly {
                ElderlyView()
            }
            
        }
        .environmentObject(authService)
        .task {
            await MainActor.run {
                isLoading = true
            }
            await authService.loadSession()
            await setRole()
            Task {
                for await notification in NotificationCenter.default.notifications(named: .authDidChange) {
                    print("auth did change")
                    await MainActor.run {
                        isLoading = true
                    }
                    await authService.setSupabaseSession(notification)
                    await setRole()
                    await MainActor.run {
                        isLoading = false
                    }
                }
            }
            await MainActor.run {
                isLoading = false
            }
        }
    }
    
    @MainActor
    private func setRole() async {
        guard let session = authService.session else { return }
        let uuid = session.user.id.uuidString
        let role = await profileService.getRole(uuid: uuid)
        authService.role = role
    }
}

#Preview {
    ContentView()
    
}
