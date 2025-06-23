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
    @State private var activeEmergency: Emergency?
    
    var body: some View {
        SOSButtonView(size: 300) {
            Task {
                let uid = authService.user!.id.uuidString
                await notificationService.sendSOSNotification(fromUserId: uid)
                let emergency = await emergencyService.insertEmergency(
                    elder_id: uid, longitude: locationManager.longitude ?? 0,
                    latitude: locationManager.latitude ?? 0
                )
                await MainActor.run {
                    activeEmergency = emergency
                }
            }
        } onDeactivate: {
            if let emergencyId = activeEmergency?.id {
                Task {
                    await emergencyService.endEmergencyWithoutReason(id: emergencyId)
                    await MainActor.run {
                        activeEmergency = nil
                    }
                }
            }
        }
        .navigationTitle("SOS")
        .task {
            
        }
    }
}

#Preview {
    ElderlySOSView()
}
