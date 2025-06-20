//
//  ElderlySOSView.swift
//  SoonToBeNamed
//
//  Created by Darrell Cornelius Rivaldo on 18/06/25.
//

import SwiftUI
import CoreLocation

struct ElderlySOSView: View {
    @EnvironmentObject var authService: AuthService
    let notificationService = NotificationService()
    let locationManager = LocationManager()
    
    var body: some View {
        Button {
            Task {
                await notificationService.sendSOSNotification(fromUserId: authService.user!.id.uuidString)
            }
        } label: {
            ZStack {
                Circle()
                    .fill(Color.red)
                    .padding(28)
                Circle()
                    .fill(Color.yellow)
                    .padding(56)
                Circle()
                    .fill(Color.red)
                    .padding(84)
                Text("SOS")
                    .font(.system(size: 64, weight: .bold))
                    .foregroundStyle(.white)
            }
        }
        .task {
            
        }
    }
}

#Preview {
    ElderlySOSView()
}
