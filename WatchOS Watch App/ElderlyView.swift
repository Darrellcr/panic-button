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
    
    @State private var isActivated: Bool = false
    @State private var fill: CGFloat = 0.0
    
    var body: some View {
        SOSButtonView(fill: $fill, isActivated: $isActivated) {
            Task {
                if let elderId = authService.session?.user.id.uuidString {
                    await notificationService.sendSOSNotification(fromUserId: elderId)
                    await emergencyService.insertEmergency(
                        elder_id: elderId,
                        longitude: locationManager.longitude ?? 0,
                        latitude: locationManager.latitude ?? 0
                    )
                }
            }
        } onDeactivate: {
            Task {
                if let uid = authService.session?.user.id.uuidString {
                    let emergency = await emergencyService.getActiveEmergencyByElderId(elderId: uid)
                    if let emergency {
                        await emergencyService.endEmergencyWithoutReason(id: emergency.id)
                        
                    }
                }
            }
        }
        .buttonStyle(.plain)
        .task {
            await checkEmergency()
            _ = Timer.scheduledTimer(withTimeInterval: 8.0, repeats: true) { _ in
                Task {
                    await checkEmergency()
                }
            }
        }
    }
    
    @MainActor
    private func checkEmergency() async {
        guard let uid = authService.session?.user.id.uuidString else { return }
        let emergency = await emergencyService.getActiveEmergencyByElderId(elderId: uid)
        guard let emergency else {
            isActivated = false
            fill = 0.0
            return
        }
        isActivated = true
        fill = 1.0
    }
}

#Preview {
    ElderlyView()
}
