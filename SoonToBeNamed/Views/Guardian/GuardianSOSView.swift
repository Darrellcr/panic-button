//
//  GuardianSOSView.swift
//  SoonToBeNamed
//
//  Created by Darrell Cornelius Rivaldo on 18/06/25.
//

import SwiftUI
import MapKit

struct GuardianSOSView: View {
    var emergencyExist: Bool = false
    let locationManager = LocationManager()
    @State private var region = MapCameraPosition.region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: -7.0, longitude: 112.0),
            span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        )
    )
    
    var body: some View {
        Map(position: $region) {
            if let lat = locationManager.latitude,
               let lon = locationManager.longitude,
               let alt = locationManager.altitude {
                let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
                Annotation("Lokasi Saat Ini", coordinate: coordinate) {
                    Image(systemName: "mappin")
                        .font(.title)
                        .foregroundColor(.blue)
                    
                    Text("Altitude: \(alt, specifier: "%.2f") m")
                                      .font(.caption2)
                                      .foregroundColor(.black)
                                      .padding(4)
                                      .background(Color.white.opacity(0.7))
                                      .cornerRadius(5)
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
