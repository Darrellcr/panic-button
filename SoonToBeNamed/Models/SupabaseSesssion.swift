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
    
    public func getRole() async {
        print("getrole called")
        guard let userId = self.user?.id else { return }
        print(userId.uuidString)
        do {
            let response = try await supabase
                .from("profiles")
                .select()
                .execute()
            print(response)
        } catch {
            print(error)
            print("empty")
        }
        
    }
}
