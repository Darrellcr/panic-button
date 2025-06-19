//
//  SelectableContactRowView.swift
//  SafeTap
//
//  Created by Darrell Cornelius Rivaldo on 19/06/25.
//

import SwiftUI

struct SelectableContactRowView: View {
    let fullName: String
    let email: String
    @Binding var isOn: Bool
    
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
    SelectableContactRowView(
        fullName: "John Doe",
        email: "johndoe@example.com",
        isOn: .constant(true)
    )
}
