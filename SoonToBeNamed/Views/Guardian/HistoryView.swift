//
//  HistoryView.swift
//  SafeTap
//
//  Created by Darrell Cornelius Rivaldo on 23/06/25.
//

import SwiftUI
import CoreLocation

struct HistoryView: View {
    let geocoder = CLGeocoder()
    @State var placeName: String = ""
    
    var body: some View {
       Text(placeName)
            .task {
                getPlaceName(from: CLLocation(latitude: -6.1751, longitude: 106.8650))
            }
            
    }
    
    func getPlaceName(from location: CLLocation) {
            geocoder.reverseGeocodeLocation(location) { placemarks, error in
                if let error = error {
                    print("Geocoding error: \(error.localizedDescription)")
                    self.placeName = "Unknown location"
                    return
                }
                
                if let placemark = placemarks?.first {
                    let name = placemark.name ?? ""
                    let city = placemark.locality ?? ""
                    let country = placemark.country ?? ""
                    DispatchQueue.main.async {
                        self.placeName = "\(name)"
                    }
                } else {
                    self.placeName = "No placemark found"
                }
            }
        }
}
#Preview {
    HistoryView()
}
