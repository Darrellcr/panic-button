//
//  ProfileService.swift
//  SoonToBeNamed
//
//  Created by Darrell Cornelius Rivaldo on 17/06/25.
//

import Foundation
import Supabase

class ProfileService {
    public func getRole(uuid: String) async -> Role? {
        do {
            let profile: Profile = try await supabase
                .from("profiles")
                .select()
                .eq("id", value: uuid)
                .single()
                .execute()
                .value
            return profile.role
        } catch {
            print(error)
            return nil
        }
    }
    
    public func updateRole(uuid: String, role: Role) async -> Bool {
        do {
            try await supabase
                .from("profiles")
                .update(["role": role])
                .eq("id", value: uuid)
                .execute()
            
            return true
        } catch {
            return false
        }
    }
}
