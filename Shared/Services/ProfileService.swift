//
//  ProfileService.swift
//  SoonToBeNamed
//
//  Created by Darrell Cornelius Rivaldo on 17/06/25.
//

import Foundation
import Supabase

class ProfileService {
    public func getProfile(uuid: String) async -> Profile? {
        do {
            return try await supabase
                .from("profiles")
                .select()
                .eq("id", value: uuid)
                .single()
                .execute()
                .value
        } catch {
            print(error)
            return nil
        }
    }
    
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
    
    public func getOnboardingStatus(uuid: String) async -> Bool? {
        do {
            let profile: Profile = try await supabase
                .from("profiles")
                .select()
                .eq("id", value: uuid)
                .single()
                .execute()
                .value
            return profile.onboarded
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
    
    public func finishOnboarding(uuid: String) async -> Bool {
        do {
            try await supabase
                .from("profiles")
                .update(["onboarded": true])
                .eq("id", value: uuid)
                .execute()
            
            return true
        } catch {
            return false
        }
    }
}
