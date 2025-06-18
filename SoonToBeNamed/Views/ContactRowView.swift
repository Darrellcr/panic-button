//
//  ContactRowView.swift
//  SoonToBeNamed
//
//  Created by Darrell Cornelius Rivaldo on 18/06/25.
//

import SwiftUI

struct ContactRowView: View {
    let fullName: String
    let email: String
    
    var body: some View {
        HStack {
            Circle()
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [.red, .blue]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 40, height: 40)
            
            VStack(alignment: .leading) {
                Text(fullName)
                Text(verbatim: email)
                    .font(.footnote)
//                    .textSelection(.disabled)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

#Preview {
    ContactRowView(
        fullName: "Darrell Cornelius Rivaldo",
        email: "email@example.com"
    )
}
