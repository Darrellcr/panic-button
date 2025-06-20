//
//  LocationManager.swift
//  SafeTap
//
//  Created by Darrell Cornelius Rivaldo on 20/06/25.
//

import Foundation
import CoreLocation
import Combine

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private var locationManager = CLLocationManager()
    private var timer: Timer?

    @Published var latitude: Double?
    @Published var longitude: Double?
    @Published var altitude: Double?

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let latest = locations.first else { return }
        DispatchQueue.main.async {
            self.latitude = latest.coordinate.latitude
            self.longitude = latest.coordinate.longitude
            self.altitude = latest.altitude
        }
    }

    func startSendingLocationEvery5Seconds() {
        stopSendingLocation() // agar tidak double timer
        timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { _ in
            if let lat = self.latitude, let lon = self.longitude {
                print("Mengirim lokasi: \(lat), \(lon)")
                // Di sini kamu bisa kirim ke server atau Firebase
            }
        }
    }

    func stopSendingLocation() {
        timer?.invalidate()
        timer = nil
    }
}
