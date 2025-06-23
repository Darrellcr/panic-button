//
//  DeviceToken.swift
//  SoonToBeNamed
//
//  Created by Darrell Cornelius Rivaldo on 14/06/25.
//

import Foundation

struct DeviceToken: Codable {
    let id: Int
    let userId: UUID
    let deviceToken: String
    let deviceType: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case deviceToken = "device_token"
        case deviceType = "device_type"
    }
}
