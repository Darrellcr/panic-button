//
//  ElderlySOSView.swift
//  SoonToBeNamed
//
//  Created by Darrell Cornelius Rivaldo on 18/06/25.
//

import SwiftUI
import Supabase
import CoreLocation

struct ElderlySOSView: View {
    @EnvironmentObject var authService: AuthService
    let emergencyService = EmergencyService()
    let notificationService = NotificationService()
    let locationManager = LocationManager()
    
    @State private var fill: CGFloat = 0.0
    @State private var isActivated: Bool = false
    
    var body: some View {
        SOSButtonView(size: 300, fill: $fill, isActivated: $isActivated) {
            Task {
                let uid = authService.user!.id.uuidString
                await notificationService.sendSOSNotification(fromUserId: uid)
                await emergencyService.insertEmergency(
                    elder_id: uid, longitude: locationManager.longitude ?? 0,
                    latitude: locationManager.latitude ?? 0
                )
            }
        } onDeactivate: {
            
            Task {
                if let uid = authService.user?.id.uuidString {
                    let emergency = await emergencyService.getActiveEmergencyByElderId(elderId: uid)
                    if let emergency {
                        await emergencyService.endEmergencyWithoutReason(id: emergency.id)
                    }
                }
            }
            
        }
        .navigationTitle("SOS")
        .task {
            await checkEmergency()
            await subscribeToRealtimeUpdates()
        }
    }
    
    private func subscribeToRealtimeUpdates() async {
        let channel = supabase.channel("emergencies")
        let changeStream = channel.postgresChange(
          AnyAction.self,
          schema: "public",
          table: "emergencies"
        )
        
        await channel.subscribe()
        Task {
            for await change in changeStream {
                switch change {
                case .insert(_):
                    await checkEmergency()
                    break
                case .update(_):
                    await checkEmergency()
                    break
                case .delete(_):
                    await checkEmergency()
                    break
                }
            }
        }
    }
    
    @MainActor
    private func checkEmergency() async {
        guard let uid = authService.user?.id.uuidString else { return }
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
    ElderlySOSView()
}
