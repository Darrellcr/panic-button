//
//  ElderlyView.swift
//  SafeTap Watch App
//
//  Created by Darrell Cornelius Rivaldo on 22/06/25.
//

import SwiftUI

struct ElderlyView: View {
    @EnvironmentObject private var authService: AuthService
    var body: some View {
        Button {
            Task {
                do {
                    if let elderId = authService.session?.user.id.uuidString {
                        try await supabase.functions
                            .invoke(
                                "send-notification",
                                options: .init(
                                    method: .post,
                                    body: ["elderId": elderId]
                                )
                            )
                    }
                } catch {
                    print(error)
                }
            }
        } label: {
            SOSButtonView()
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    ElderlyView()
}
