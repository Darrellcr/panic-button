//
//  EmergencyService.swift
//  SafeTap
//
//  Created by Darrell Cornelius Rivaldo on 20/06/25.
//

import Foundation

class EmergencyService {
    func insertEmergency(elder_id: String, longitude: Double, latitude: Double) async -> Emergency? {
        let emergency = EmergencyRequestBody(
            elder_id: elder_id, longitude: longitude, latitude: latitude
        )
        do {
            let insertedEmergency: Emergency = try await supabase
                .from("emergencies")
                .insert(emergency)
                .execute()
                .value
            
            return insertedEmergency
        } catch {
            print("Error inserting emergency \(error)")
            return nil
        }
    }
    
    func getActiveEmergency(guardianId: String) async -> Emergency? {
        do {
            let guardians: [Guardian] = try await supabase
                .from("guardians")
                .select()
                .eq("guardian_id", value: guardianId)
                .execute()
                .value
            
            let uuids = guardians.map { $0.elderId.uuidString }

            let emergency: Emergency? = try await supabase
                .from("emergencies")
                .select()
                .eq("resolved", value: false)
                .in("elder_id", values: uuids)
                .order("created_at", ascending: false)
                .limit(1)
                .single()
                .execute()
                .value
            
            return emergency
        } catch {
            print("Error getting active emergency \(error)")
            return nil
        }
    }
    
    func getAllEmergencies(elderId: String) async -> [Emergency] {
        do {
            let emergencies: [Emergency] = try await supabase
                .from("emergencies")
                .select()
                .eq("elder_id", value: elderId)
                .execute()
                .value
            
            return emergencies
        } catch {
            print("Fail to get all emergency \(error)")
            return []
        }
    }
    
    func endEmergency(id: Int, reason: String) async {
        do {
            try await supabase
                .from("emergencies")
                .update(EndEmergencyRequestBody(
                    id: id,
                    resolved: true,
                    reason: reason
                ))
                .eq("id", value: id)
                .execute()
        } catch {
            print("fail to end emergency \(error)")
        }
    }
    
    func endEmergencyWithoutReason(id: Int) async {
        do {
            try await supabase
                .from("emergencies")
                .update(EndEmergencyRequestBody(
                    id: id,
                    resolved: true,
                ))
                .eq("id", value: id)
                .execute()
        } catch {
            print("fail to end emergency \(error)")
        }
    }
}
