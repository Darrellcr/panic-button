//
//  AuthService.swift
//  SafeTap Watch App
//
//  Created by Darrell Cornelius Rivaldo on 19/06/25.
//

import Foundation
import Supabase

class AuthService {
    var session: Session?
    
    func loadSession() async {
        do {
            session = try await supabase.auth.session
            print("access token: \(self.session?.accessToken)")
        } catch {
            print("Error loading session: \(error)")
        }
    }
    
    @objc
    func setSupabaseSession(_ notification: Notification) {
        guard let context = notification.object as? [String: Any] else { return }
        
        guard let accessToken = context["accessToken"] as? String,
              let refreshToken = context["refreshToken"] as? String
        else { return }
        
        Task {
            do {
                session = try await supabase.auth.setSession(
                    accessToken: accessToken, refreshToken: refreshToken)
                print(session)
            } catch {
                print("Error setting Supabase session: \(error)")
            }
        }
    }
}
