//
//  SOSButtonView.swift
//  SafeTap Watch App
//
//  Created by Darrell Cornelius Rivaldo on 19/06/25.
//

import SwiftUI

struct SOSButtonView: View {
    let size: CGFloat
    
    init(size: CGFloat = 150) {
        self.size = size
    }
    
    var body: some View {
        ZStack {
            // Bayangan luar lembut
            Circle()
                .fill(Color.black)
                .frame(width: size, height: size)
                .shadow(color: Color.black, radius: 10, x: 0, y: 0)
                .overlay(
                    // Garis luar tipis glossy
                    Circle()
                        .strokeBorder(
                            LinearGradient(
                                colors: [.white.opacity(0.6), .clear],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 3
                        )
                )
                .overlay(
                    // Inner glossy shine (highlight)
                    Circle()
                        .fill(Color.blood)
                        .blur(radius: 2)
                        .padding(6)
                )
            
            #if os(iOS)
            Text("SOS")
                .font(.system(size: 72))
                .bold()
                .foregroundStyle(.white)
            #elseif os(watchOS)
            Text("SOS")
                .font(.largeTitle)
                .bold()
                .foregroundStyle(.white)
            #endif
        }
    }
}

#Preview {
    SOSButtonView()
}
