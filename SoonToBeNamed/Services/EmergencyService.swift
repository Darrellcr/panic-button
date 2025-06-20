//
//  EmergencyService.swift
//  SafeTap
//
//  Created by Darrell Cornelius Rivaldo on 20/06/25.
//

import Foundation

class EmergencyService {
    func insertEmergency(elder_id: String, longitude: Double, latitude: Double) async {
        let emergency = EmergencyRequestBody(
            elder_id: elder_id, longitude: longitude, latitude: latitude
        )
        do {
            try await supabase
                .from("emergencies")
                .insert(emergency)
                .execute()
        } catch {
            print("Error inserting emergency \(error)")
        }
    }
}
