//
//  ContentView.swift
//  WatchOS Watch App
//
//  Created by Calvin Christian Tjong on 18/06/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
            ZStack {
                // Bayangan luar lembut
                Circle()
                    .fill(Color.black)
                    .frame(width: 150, height: 150)
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
                
                // Ikon SOS tengah (pakai SF Symbol sementara)
                Text("SOS")
                    .font(.largeTitle)
                    .bold()
                    .foregroundStyle(.white)
                
            }

        HStack {
            Image("logo_transparent")
                .resizable()
                .clipShape(Circle())
                .frame(width: 40, height: 40)
            Text("SafeTap")
            
        }
        .frame(width: 200)
        .offset(x:-10)
    }
    
}

#Preview {
    ContentView()
    
}
