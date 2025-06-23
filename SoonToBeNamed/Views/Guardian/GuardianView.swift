//
//  GuardianView.swift
//  SoonToBeNamed
//
//  Created by Calvin Christian Tjong on 17/06/25.
//

import SwiftUI

struct GuardianView: View {
    @EnvironmentObject var authService: AuthService
    @State var showAlert: Bool = false
    @State var profile: Profile?
    @State var elderProfile: Profile?
    let guardianService = GuardianService()
    let profileService = ProfileService()
    let notificationService = NotificationService()
    
    var body: some View {
        
        
        TabView {
            
            Tab("SOS", systemImage: "sos.circle.fill"){
                NavigationStack {
                    GuardianSOSView()
                        .toolbarBackground(.hidden, for: .tabBar)
                        .toolbarBackground(.hidden, for: .navigationBar)
                        .toolbar {
                            ToolbarItem(placement: .topBarTrailing) {
                                NavigationLink(destination: GuardianProfileView(profile: profile)) {
                                    ProfilePictureView()
                                }
                            }
                        }
                }
            }
            
            Tab("History", systemImage: "list.clipboard"){
                NavigationStack {
                    GuardianHistoryView()
                        .toolbarBackground(.hidden, for: .tabBar)
                        .toolbarBackground(.hidden, for: .navigationBar)
                        .toolbar {
                            ToolbarItem(placement: .topBarTrailing) {
                                NavigationLink(destination: GuardianProfileView(profile: profile)) {
                                    ProfilePictureView()
                                }
                            }
                        }
                }
                
            }
            
            
            
        }
        
        .alert("Guardian Invitation", isPresented: $showAlert, presenting: elderProfile) { elderProfile in
            Button("Accept") {
                Task {
                    let success = await guardianService.acceptInvitation(elderId: elderProfile.id.uuidString, guardianId: authService.user!.id.uuidString)
                    print(success)
                    if success {
                        await MainActor.run {
                            showAlert = false
                        }
                    }
                }
            }
            Button("Decline") {
                showAlert = false
            }
        } message: { elderProfile in
            Text("Do you want to be the guardian for: \(elderProfile.fullName!)?")
        }
        .task {
            notificationService.registerForRemoteNotifications()
            let p = await profileService.getProfile(uuid: authService.user!.id.uuidString)
            await MainActor.run {
                profile = p
            }
            for await notification in NotificationCenter.default.notifications(named: .invitationReceived) {
                let profile = notification.object as! Profile
                Task {
                    await MainActor.run {
                        elderProfile = profile
                        showAlert = true
                    }
                }
            }
        }
    }

}

#Preview {
    GuardianView()
}
