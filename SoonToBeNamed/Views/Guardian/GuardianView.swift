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
    @State var elderProfile: Profile?
    let guardianService = GuardianService()
    
    var body: some View {
        VStack {
            Text("Guardian View")
            Button("Logout") {
                Task {
                    do {
                        try await authService.logout()
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
