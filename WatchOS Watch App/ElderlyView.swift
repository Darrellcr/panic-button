//
//  ElderlyView.swift
//  SafeTap Watch App
//
//  Created by Darrell Cornelius Rivaldo on 22/06/25.
//

import SwiftUI

struct ElderlyView: View {
    @EnvironmentObject private var authService: AuthService
    let notificationService = NotificationService()
    let emergencyService = EmergencyService()
    let locationManager = LocationManager()
    
    @State private var activeEmergency: Emergency?
    
    var body: some View {
        SOSButtonView() {
            Task {
                if let elderId = authService.session?.user.id.uuidString {
                    await notificationService.sendSOSNotification(fromUserId: elderId)
                    let emergency = await emergencyService.insertEmergency(
                        elder_id: elderId,
                        longitude: locationManager.longitude ?? 0,
                        latitude: locationManager.latitude ?? 0
                    )
                    await MainActor.run {
                        activeEmergency = emergency
                    }
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
        .buttonStyle(.plain)
    }
}

#Preview {
    ElderlyView()
}
