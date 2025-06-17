//
//  SwiftUIView.swift
//  SoonToBeNamed
//
//  Created by Darrell Cornelius Rivaldo on 17/06/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var supabaseSession = SupabaseSession()
    
    var body: some View {
        Group {
//            if !supabaseSession.isAuthenticated {
//                AuthView()
//            }
            AuthView()
            Button("asd") {
                Task {
                    await supabaseSession.getRole()                    
                }
            }
        }
        .task {
            Task {
                do {
                    supabaseSession.session = try await supabase.auth.session
                    supabaseSession.user = supabase.auth.currentUser
                    supabaseSession.isAuthenticated = true
                } catch {
                    supabaseSession.isAuthenticated = false
                }
                
            }
        }
    }
}

#Preview {
    ContentView()
}
