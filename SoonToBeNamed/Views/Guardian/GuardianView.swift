//
//  GuardianView.swift
//  SoonToBeNamed
//
//  Created by Calvin Christian Tjong on 17/06/25.
//

import SwiftUI

struct GuardianView: View {
    @EnvironmentObject var authService: AuthService
    private let notificationService = NotificationService()
    
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
        .task {
            Task {
                notificationService.registerForRemoteNotifications()
            }
        }
    }
}

#Preview {
    GuardianView()
}
