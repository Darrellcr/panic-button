//
//  Guardian.swift
//  SafeTap
//
//  Created by Darrell Cornelius Rivaldo on 22/06/25.
//

import Foundation

struct Guardian: Codable {
    let id: Int
    let elderId: UUID
    let guardianId: UUID
    
    enum CodingKeys: String, CodingKey {
        case id
        case elderId = "elder_id"
        case guardianId = "guardian_id"
    }
}
