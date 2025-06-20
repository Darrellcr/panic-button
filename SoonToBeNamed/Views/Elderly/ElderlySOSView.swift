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
    let emergencyService = EmergencyService()
    let notificationService = NotificationService()
    let locationManager = LocationManager()
    
    var body: some View {
        Button {
            Task {
                let uid = authService.user!.id.uuidString
                await notificationService.sendSOSNotification(fromUserId: uid)
                await emergencyService.insertEmergency(
                    elder_id: uid, longitude: locationManager.longitude ?? 0, latitude: locationManager.latitude ?? 0)
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
