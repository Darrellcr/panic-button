//
//  AuthService.swift
//  SafeTap Watch App
//
//  Created by Darrell Cornelius Rivaldo on 19/06/25.
//

import Foundation
import Supabase

class AuthService: ObservableObject {
    @Published var session: Session?
    @Published var role: Role?
    
    func loadSession() async {
        do {
            session = try await supabase.auth.session
            print("successfully loaded session")
        } catch {
            print("Error loading session: \(error)")
        }
    }
    
    func setSupabaseSession(_ notification: Notification) async {
        guard let context = notification.object as? [String: Any] else { return }
        
        guard let accessToken = context["accessToken"] as? String,
              let refreshToken = context["refreshToken"] as? String
        else { return }
        
        guard accessToken != "" else {
            do {
                try await supabase.auth.signOut()
                print("signed out")
            } catch {
                print("failed to sign out: \(error)")
            }
            
            return
        }
        
        do {
            session = try await supabase.auth.setSession(
                accessToken: accessToken, refreshToken: refreshToken)
        } catch {
            print("Error setting Supabase session: \(error)")
        }
        
    }
}
