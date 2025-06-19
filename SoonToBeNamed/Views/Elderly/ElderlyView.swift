//
//  ElderlyView.swift
//  SoonToBeNamed
//
//  Created by Calvin Christian Tjong on 17/06/25.
//

import SwiftUI

struct ElderlyView: View {
    @EnvironmentObject var authService: AuthService
    private let notificationService = NotificationService()
    
    var body: some View {
        Text("Elderly")
        Button("Logout") {
            Task {
                do {
                    try await authService.logout()
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
