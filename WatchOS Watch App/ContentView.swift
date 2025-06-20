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
<<<<<<< HEAD
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
    
    
=======
            ZStack {
                // Bayangan luar lembut
                Circle()
                    .fill(Color.black)
                    .frame(width: 150, height: 150)
                    .shadow(color: Color.black, radius: 10, x: 0, y: 0)
                    .overlay(
                        // Garis luar tipis glossy
                        Circle()
                            .strokeBorder(
                                LinearGradient(
                                    colors: [.white.opacity(0.6), .clear],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 3
                            )
                    )
                    .overlay(
                        // Inner glossy shine (highlight)
                        Circle()
                            .fill(Color.blood)
                            .blur(radius: 2)
                            .padding(6)
                    )
                
                // Ikon SOS tengah (pakai SF Symbol sementara)
                Text("SOS")
                    .font(.largeTitle)
                    .bold()
                    .foregroundStyle(.white)
                
            }

        HStack {
            Image("logo_transparent")
                .resizable()
                .clipShape(Circle())
                .frame(width: 40, height: 40)
            Text("SafeTap")
            
        }
        .frame(width: 200)
        .offset(x:-10)
    }
    
>>>>>>> main
}

#Preview {
    ContentView()
    
}
