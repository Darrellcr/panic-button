//
//  GuardianService.swift
//  SafeTap
//
//  Created by Darrell Cornelius Rivaldo on 19/06/25.
//

import Foundation

class GuardianService {
    func addGuardians(userId: String, guardianIds: [String]) async {
        var rows: [[String: String]] = []
        for guardianId in guardianIds {
            let row: [String: String] = [
                "elder_id": userId,
                "guardian_id": guardianId,
                "updated_at": formattedDateString()
            ]
            rows.append(row)
        }
        do {
            try await supabase
                .from("guardians")
                .insert(rows)
                .execute()
        } catch {
            print(error)
        }
    }
    
    func getAllGuardians() async -> [Profile] {
        do {
            var profiles: [Profile] = try await supabase
                    .from("profiles")
                    .select()
                    .eq("role", value: Role.guardian.rawValue)
                    .execute()
                    .value
            
            return profiles
        } catch {
            print("Fail to get guardians \(error)")
            return []
        }
    }
    
    func getConfirmedGuardiansOfUser(userId: String) async -> [ConfirmedGuardian] {
        do {
            let confirmedGuardian: [ConfirmedGuardian] = try await supabase
                .from("guardians")
                .select("guardian_id")
                .eq("elder_id", value: userId)
                .eq("confirmed_by_guardian", value: true)
                .execute()
                .value
            
            return confirmedGuardian
        } catch {
            print("Fail to get confirmed guardians of user \(error)")
            return []
        }
    }
    
    private func formattedDateString() -> String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        return formatter.string(from: Date())
    }
}

struct ConfirmedGuardian: Codable {
    let guardianId: UUID
    
    enum CodingKeys: String, CodingKey {
        case guardianId = "guardian_id"
    }
}
