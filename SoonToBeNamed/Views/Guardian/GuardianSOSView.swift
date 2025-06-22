//
//  GuardianSOSView.swift
//  SoonToBeNamed
//
//  Created by Darrell Cornelius Rivaldo on 18/06/25.
//

import SwiftUI
import MapKit
import Supabase

struct GuardianSOSView: View {
    @EnvironmentObject var authService: AuthService
    let emergencyService = EmergencyService()
    let profileService = ProfileService()
    
    @State var isLoading = true
    @StateObject var locationManager = LocationManager()
    @State var showEndEmergencyAlert = false
    @State var emergencyReason: String = ""
    
    @State private var emergency: Emergency?
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
                VStack(spacing: 16) {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .secondary))
                        .scaleEffect(2)
                }
            } else if let elderCoordinate {
                EmergencyView(elderCoordinate)
            }
            else{
                EmptyStateView
            }
        }
        .task {
            await checkEmergency()
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
                    case .insert(let action):
                        let activeEmergency = castRecordToEmergency(record: action.record)
                        await updateMap(activeEmergency: activeEmergency)
                        break
                    case .update(let action):
                        let activeEmergency = castRecordToEmergency(record: action.record)
                        await updateMap(activeEmergency: activeEmergency)
                        break
                    case .delete(let action):
                        await checkEmergency()
                        break
                    }
                }
            }
            Task {
                for await notification in NotificationCenter.default.notifications(named: .invitationReceived) {
                    await checkEmergency()
                }
            }
            
        }
    }
    
    func castRecordToEmergency(record: [String: AnyJSON]) -> Emergency {
        return try! record.decode(as: Emergency.self)
    }

    
    @MainActor
    func checkEmergency() async {
        isLoading = true
        let userId = authService.user!.id.uuidString
        let activeEmergency = await emergencyService.getActiveEmergency(guardianId: userId)
        guard let activeEmergency else {
            elderCoordinate = nil
            emergency = nil
            isLoading = false
            return
        }
        
        await updateMap(activeEmergency: activeEmergency)
    }
    
    @MainActor
    func updateMap(activeEmergency: Emergency) async {
        emergency = activeEmergency
        let elder = await profileService.getProfile(uuid: activeEmergency.elderId)
        
        guard let elder else { return }
        
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
    
    var EmptyStateView: some View {
        VStack {
            Text("Your loved one is safe")
                .font(.largeTitle)
                .bold()
        }
    }
    
    fileprivate func EmergencyView(_ elderCoordinate: CLLocationCoordinate2D) -> some View {
        return VStack{
            MapView(elderCoordinate)
            Button(action: {
                showEndEmergencyAlert.toggle()
            }) {
                Text("End Emergency")
                    .font(.headline)
                    .foregroundStyle(.backColor2)
                    .frame(width: 350, height: 50) // Ukuran tombol
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white) // Warna latar tombol
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.backColor2, lineWidth: 2) // Garis tepi
                    )
            }
            
        }
        .alert("Please insert the reason elderly click the SOS", isPresented: $showEndEmergencyAlert) {
            //            TextField("Reason", value: $textField, format:.)
            TextField("", text: $emergencyReason)
            Button("Cancel", role: .cancel){
                emergencyReason = ""
            }
            Button("Done"){
                Task {
                    await emergencyService.endEmergency(id: emergency!.id, reason: emergencyReason)
                    await checkEmergency()
                    emergencyReason = ""
                }
            }.disabled(emergencyReason.isEmpty)
        }
    }

    fileprivate func MapView(_ elderCoordinate: CLLocationCoordinate2D) -> some View {
        return Map(position: $region) {
            if let lat = locationManager.latitude,
               let lon = locationManager.longitude,
               let alt = locationManager.altitude {
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
        .frame(height: 340)
        .clipShape(Circle())
        .overlay(
            Circle()
                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
        )
        .frame(height: 360)
        .shadow(radius: 5)
        .cornerRadius(12)
    }
}


#Preview {
    GuardianSOSView()
}
