//
//  OnboardingAddGuardianView.swift
//  SoonToBeNamed
//
//  Created by Darrell Cornelius Rivaldo on 18/06/25.
//

import SwiftUI

struct OnboardingAddGuardianView: View {
    var body: some View {
        VStack {
            Text("Add your guardian")
            VStack {
                Text("Guardian Contact")
                List {
                    ForEach(1..<5, id: \.self) { number in
                        ContactRowView(
                            fullName: "Darrell", email: "email@example.com"
                        )
                    }
                    .onDelete(perform: { offsets in
                        print(offsets)
                    })
                }
//                .frame(maxHeight: 200)
            }
            .frame(maxHeight: .infinity)
        }
    }
}

#Preview {
    OnboardingAddGuardianView()
}
