//
//  GuardianProfileView.swift
//  SafeTap
//
//  Created by Darrell Cornelius Rivaldo on 23/06/25.
//

import SwiftUI
import Supabase

struct GuardianProfileView: View {
    @EnvironmentObject var authService: AuthService
    let profile: Profile?
    
    var body: some View {
        VStack {
            VStack {
                ProfilePictureView(size: 140)
                Text(profile?.fullName ?? "Full Name")
                    .font(.title)
                    .bold()
                Text(verbatim: profile?.email ?? "email@example.com")
                    .font(.title3)
            }
            
            Divider()
                .safeAreaPadding()
            
            Spacer()
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("logout") {
                    Task {
                        do {
                            try await authService.logout()
                        } catch {
                            print("Fail to logout")
                        }
                    }
                }
            }
        }
        
    }
}

#Preview {
    GuardianProfileView(
        profile: Profile(id: UUID(), fullName: "Darrell Cornelius R", email: "email@example.com")
    )
}
