//
//  Profile.swift
//  SoonToBeNamed
//
//  Created by Darrell Cornelius Rivaldo on 17/06/25.
//

import Foundation

struct Profile: Codable, Hashable, Identifiable {
    let id: UUID
    let username: String?
    let fullName: String?
    let avatarURL: String?
    let email: String?
    let onboarded: Bool?
    let role: Role?
    
    enum CodingKeys: String, CodingKey {
        case id, username, email, onboarded, role
        case fullName = "full_name"
        case avatarURL = "avatar_url"
    }
}

extension Profile {
    init(id: UUID, fullName: String, email: String!) {
        self.id = id
        self.email = email
        self.fullName = fullName
        self.role = nil
        self.username = nil
        self.onboarded = nil
        self.avatarURL = nil
    }
}
