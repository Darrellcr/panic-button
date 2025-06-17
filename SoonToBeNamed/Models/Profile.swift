//
//  Profile.swift
//  SoonToBeNamed
//
//  Created by Darrell Cornelius Rivaldo on 17/06/25.
//

import Foundation

enum Role: String, Codable {
    case guardian, elderly
}

struct Profile: Codable {
    let id: UUID
    let username: String?
    let fullName: String?
    let avatarURL: String?
    let role: Role?
    
    enum CodingKeys: String, CodingKey {
        case id
        case username
        case fullName = "full_name"
        case avatarURL = "avatar_url"
        case role
    }
}
