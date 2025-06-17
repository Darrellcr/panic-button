//
//  GuardianView.swift
//  SoonToBeNamed
//
//  Created by Calvin Christian Tjong on 17/06/25.
//

import SwiftUI

struct GuardianView: View {
    @EnvironmentObject var authService: AuthService
    
    var body: some View {
        Text("Guardian View")
        Button("Logout") {
            Task {
                do {
                    try await authService.logout()
                }
            }
        }
    }
}

#Preview {
    GuardianView()
}
