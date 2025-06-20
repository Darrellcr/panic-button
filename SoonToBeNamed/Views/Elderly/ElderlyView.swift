//
//  ElderlyView.swift
//  SoonToBeNamed
//
//  Created by Calvin Christian Tjong on 17/06/25.
//

import SwiftUI

struct ElderlyView: View {
    @EnvironmentObject var authService: AuthService
    let profileService = ProfileService()
    @State var profile: Profile?
    
    var body: some View {
        NavigationStack {
            TabView {
                Tab("SOS", systemImage: "sos.circle") {
                    ElderlySOSView()
                }
                Tab("History", systemImage: "list.bullet.clipboard.fill") {
                    Button("Logout") {
                        Task {
                            do {
                                try await authService.logout()
                            }
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink(destination: ElderlyProfileView(profile: profile)) {
                        ProfilePictureView()
                    }
                }
            }
            .task {
                Task {
                    let p = await profileService.getProfile(uuid: authService.user!.id.uuidString)
                    await MainActor.run {
                        profile = p
                    }
                }
            }
        }
        
    }
}

#Preview {
    ElderlyView()
}
