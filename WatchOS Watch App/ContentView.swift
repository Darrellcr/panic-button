//
//  ContentView.swift
//  WatchOS Watch App
//
//  Created by Calvin Christian Tjong on 18/06/25.
//

import SwiftUI

struct ContentView: View {
    let authService = AuthService()
    
    var body: some View {
        Button {
            Task {
                do {
                    try await supabase.functions
                        .invoke(
                            "send-notification",
                            options: .init(
                                method: .post,
                                body: ["deviceToken": "edfbfda70a52426d7310f752392454eafb701039190ed16f1a77ea1302cc9e3a"]
                            )
                        )
                } catch {
                    print(error)
                }
            }
        } label: {
            SOSButtonView()
        }
        .buttonStyle(.plain)
        .task {
            print("asd")
            Task {
                await authService.loadSession()
            }
            for await notification in NotificationCenter.default.notifications(named: .authDidChange) {
                authService.setSupabaseSession(notification)
            }
        }
    }
    
    
}

#Preview {
    ContentView()
    
}
