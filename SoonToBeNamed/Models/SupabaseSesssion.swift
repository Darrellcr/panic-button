//
//  Sesssion.swift
//  SoonToBeNamed
//
//  Created by Darrell Cornelius Rivaldo on 17/06/25.
//

import SwiftUI
import Supabase

class SupabaseSession: ObservableObject {
    @Published var session: Session?
    @Published var user: User?
    @Published var isAuthenticated = false
    
    public func getRole() async -> Role? {
        print("getrole called")
        guard let userId = self.user?.id else { return nil }
        print(userId.uuidString)
        do {
            let profile: Profile = try await supabase
                .from("profiles")
                .select()
                .eq("id", value: "8F00EB98-CBD6-4060-8D49-5EF5FC4CE55Dasd")
                .single()
                .execute()
                .value
            
            return profile.role
        } catch {
            print(error)
            return nil
        }
        
    }
}
