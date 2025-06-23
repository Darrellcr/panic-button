//
//  HistoryView.swift
//  SafeTap
//
//  Created by Darrell Cornelius Rivaldo on 23/06/25.
//

import SwiftUI
import CoreLocation

struct GuardianHistoryView: View {
    @EnvironmentObject var authService: AuthService
    let geocoder = CLGeocoder()
    let guardianService = GuardianService()
    let emergencyService = EmergencyService()
    @State var placeName: String = ""
    @State var historyItems: [HistoryItem] = []
    @State var isLoading = true
    
    var body: some View {
        VStack {
            if isLoading {
                VStack {
                    VStack(spacing: 16) {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .secondary))
                            .scaleEffect(2)
                    }
                }
            } else {
                HistoryView(historyItems: historyItems)
            }
        }
        .navigationTitle("History")
        .task {
            if let user = authService.user {  
                let uid = user.id.uuidString
                let elder = await guardianService.getElderByGuardianId(guardianId: uid)
                if let elder {
                    let emergencies = await emergencyService.getAllEmergencies(
                        elderId: elder.id.uuidString
                    )
                    let emergencyHistories = await buildHistoryItems(from: emergencies)
                    await MainActor.run {
                        self.historyItems = emergencyHistories
                        isLoading = false
                    }
                }
                
            }
        }
        
        
    }
    
    func buildHistoryItems(from emergencies: [Emergency]) async -> [HistoryItem] {
        var historyItems: [HistoryItem] = []
        
        for emergency in emergencies {
            let location = CLLocation(latitude: emergency.latitude, longitude: emergency.longitude)
            let placeName = await getPlaceName(from: location)
            
            let item = HistoryItem(
                date: emergency.createdAt,
                location: placeName,
                reason: emergency.reason ?? "-"
            )
            historyItems.append(item)
        }
        
        return historyItems
    }
    
    func getPlaceName(from location: CLLocation) async -> String {
        do {
            let placemarks = try await geocoder.reverseGeocodeLocation(location)
            if let placemark = placemarks.first {
                let name = placemark.name ?? "Unnamed"
                return name
            } else {
                return "No placemark found"
            }
        } catch {
            print("Geocoding error: \(error.localizedDescription)")
            return "Unknown location"
        }
    }
}
#Preview {
    GuardianHistoryView()
}
