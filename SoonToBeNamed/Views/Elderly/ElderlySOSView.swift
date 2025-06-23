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
            SOSButtonView(size: 300)
        }
        .navigationTitle("SOS")
        .task {
            
        }
    }
}

#Preview {
    ElderlySOSView()
}
