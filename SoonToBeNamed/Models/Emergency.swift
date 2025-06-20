//
//  Emergency.swift
//  SafeTap
//
//  Created by Darrell Cornelius Rivaldo on 20/06/25.
//

import Foundation

struct EmergencyRequestBody: Codable {
    let elder_id: String
    let longitude: Double
    let latitude: Double
}
