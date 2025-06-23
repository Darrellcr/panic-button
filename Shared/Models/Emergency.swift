//
//  Emergency.swift
//  SafeTap
//
//  Created by Darrell Cornelius Rivaldo on 20/06/25.
//

import Foundation

struct Emergency: Codable {
    let id: Int
    let elderId: String
    let longitude: Double
    let latitude: Double
    let resolved: Bool
    let reason: String?
    
    enum CodingKeys: String, CodingKey {
        case id, longitude, latitude, resolved, reason
        case elderId = "elder_id"
    }
}

struct EmergencyRequestBody: Codable {
    let elder_id: String
    let longitude: Double
    let latitude: Double
}

struct EndEmergencyRequestBody: Codable {
    let id: Int
    let resolved: Bool
    let reason: String
}
