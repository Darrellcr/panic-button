//
//  ElderlySOSView.swift
//  SoonToBeNamed
//
//  Created by Darrell Cornelius Rivaldo on 18/06/25.
//

import SwiftUI

struct ElderlySOSView: View {
    var body: some View {
        Button {
            
        } label: {
            ZStack {
                Circle()
                    .fill(Color.red)
                    .padding(28)
                Circle()
                    .fill(Color.yellow)
                    .padding(56)
                Circle()
                    .fill(Color.red)
                    .padding(84)
                Text("SOS")
                    .font(.system(size: 64, weight: .bold))
                    .foregroundStyle(.white)
            }
        }
    }
}

#Preview {
    ElderlySOSView()
}
