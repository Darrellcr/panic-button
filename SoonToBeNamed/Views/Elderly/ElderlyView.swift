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
        
        TabView {
            Tab("SOS", systemImage: "sos.circle") {
                NavigationStack {
                    ElderlySOSView()
                        .toolbar {
                            ToolbarItem(placement: .topBarTrailing) {
                                NavigationLink(destination: ElderlyProfileView(profile: profile)) {
                                    ProfilePictureView()
                                }
                            }
                        }
                }
            }
            Tab("History", systemImage: "list.bullet.clipboard.fill") {
                NavigationStack {
                    ElderlyHistoryView()
                        .toolbar {
                            ToolbarItem(placement: .topBarTrailing) {
                                NavigationLink(destination: ElderlyProfileView(profile: profile)) {
                                    ProfilePictureView()
                                }
                            }
                        }
                }
            }
        }
        
        .task {
            Task {
                if let uid = authService.user?.id.uuidString {
                    let p = await profileService.getProfile(uuid: uid)
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
