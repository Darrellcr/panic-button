//
//  GuardianView.swift
//  SafeTap Watch App
//
//  Created by Darrell Cornelius Rivaldo on 22/06/25.
//

import SwiftUI
import MapKit
import Supabase

struct GuardianView: View {
    @EnvironmentObject var authService: AuthService
    let emergencyService = EmergencyService()
    let locationManager = LocationManager()
    
    @State private var isLoading = false
    @State private var elderCoordinate: CLLocationCoordinate2D?
    @State private var region = MapCameraPosition.region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: -7.0, longitude: 112.0),
            span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        )
    )
    
    var body: some View {
        Group {
            if isLoading {
                LoadingView()
            } else if let elderCoordinate {
                MapView(elderCoordinate)
            } else {
                Text("Your loved on is safe")
            }
        }
        .task {
            await checkEmergency()
            await subscribeToRealtimeChannel()
        }
    }
    
    func castRecordToEmergency(record: [String: AnyJSON]) -> Emergency {
        return try! record.decode(as: Emergency.self)
    }
    
    func subscribeToRealtimeChannel() async {
        let channel = supabase.channel("emergencies")
        print("init channel")
        let changeStream = channel.postgresChange(
            AnyAction.self,
            schema: "public",
            table: "emergencies"
        )
        print("subscribing")
        
        await channel.subscribe()
        print("subscribed")
        for await change in changeStream {
            switch change {
            case .insert(let action):
                let activeEmergency = castRecordToEmergency(record: action.record)
                await updateMap(activeEmergency: activeEmergency)
                break
            case .update(let action):
                let activeEmergency = castRecordToEmergency(record: action.record)
                await updateMap(activeEmergency: activeEmergency)
                break
            case .delete( _):
                await checkEmergency()
                break
            }
        }
    }
    
    @MainActor
    func checkEmergency() async {
        isLoading = true
        guard let session = authService.session else { return }
        let userId = session.user.id.uuidString
        let activeEmergency = await emergencyService.getActiveEmergency(guardianId: userId)
        guard let activeEmergency else {
            elderCoordinate = nil
            isLoading = false
            return
        }
        
        await updateMap(activeEmergency: activeEmergency)
    }
    
    @MainActor
    func updateMap(activeEmergency: Emergency) async {
        elderCoordinate = CLLocationCoordinate2D(latitude: activeEmergency.latitude, longitude: activeEmergency.longitude)
        
        guard let userLatitude = locationManager.latitude,
              let userLongitude = locationManager.longitude else { return }
        
        let mapCenter = CLLocationCoordinate2D(
            latitude: (userLatitude + activeEmergency.latitude) / 2,
            longitude: (userLongitude + activeEmergency.longitude) / 2
        )
        let mapSpan = MKCoordinateSpan(
            latitudeDelta: abs(userLatitude - activeEmergency.latitude) * 1.5,
            longitudeDelta: abs(userLongitude - activeEmergency.longitude) * 1.5
        )
        region = MapCameraPosition.region(MKCoordinateRegion(center: mapCenter, span: mapSpan))
        isLoading = false
    }
    
    private func MapView(_ elderCoordinate: CLLocationCoordinate2D) -> some View {
        return Map(position: $region) {
            if let lat = locationManager.latitude,
               let lon = locationManager.longitude {
                let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
                Annotation("Your current location", coordinate: coordinate) {
                    Image(systemName: "mappin")
                        .font(.title)
                        .foregroundColor(.blue)
                }
                
                Annotation("Elder location", coordinate: elderCoordinate) {
                    Image(systemName: "mappin")
                        .font(.title)
                        .foregroundColor(.red)
                }
            }
        }
    }
}

#Preview {
    GuardianView()
}
