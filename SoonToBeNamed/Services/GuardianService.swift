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
                .upsert(rows, onConflict: "elder_id,guardian_id", ignoreDuplicates: false)
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
    
    func getConfirmedGuardiansOfUser(userId: String) async -> [Profile] {
        do {
            let confirmedGuardians: [Profile] = try await supabase
                .from("profiles")
                .select("*, guardians:guardians!guardians_guardian_id_fkey!inner(elder_id, confirmed_by_guardian)")
                .eq("guardians.elder_id", value: userId)
                .eq("guardians.confirmed_by_guardian", value: true)
                .execute()
                .value
            
            return confirmedGuardians
        } catch {
            print("Fail to get confirmed guardians of user \(error)")
            return []
        }
    }
    
    func acceptInvitation(elderId: String, guardianId: String) async -> Bool {
        do {
            print(elderId)
            print(guardianId)
            try await supabase
                .from("guardians")
                .update(["confirmed_by_guardian": true])
                .eq("elder_id", value: elderId)
                .eq("guardian_id", value: guardianId)
                .execute()
            return true
        } catch {
            print("Fail to accept invitation \(error)")
            return false
        }
    }
    
    private func formattedDateString() -> String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        return formatter.string(from: Date())
    }
}
