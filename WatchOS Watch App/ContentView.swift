//
//  ContentView.swift
//  WatchOS Watch App
//
//  Created by Calvin Christian Tjong on 18/06/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
//        ZStack {
//            Circle()
//                .fill(Color.white)
//                .frame(width: 190, height: 190)
//                .blur(radius: 2)
//                .overlay(
//                    Circle()
//                        .fill(Color.black)
//                        .frame(width: 180, height: 180)
////                        .blur(radius: 2)
//                )
//                .overlay(
//                    Circle()
//                        .fill(
//                            LinearGradient(
//                                colors: [Color.red.opacity(0.8), Color.red],
//                                startPoint: .bottom,
//                                endPoint: .top
//                            )
//                        )
//                        .frame(width: 165, height: 165)
//                    
//                )
//           Text("SOS")
//                           .font(.system(size: 38))
////                           .multilineTextAlignment(.center)
//                           .foregroundColor(.white)
//                           .bold()
//        }
//
//    }
    
    
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
//                                .fill(
//                                    LinearGradient(
//                                        colors: [Color.blood, Color.red],
//                                        startPoint: .top,
//                                        endPoint: .bottom
//                                    )
////                                    Co
//                                )
                                .blur(radius: 2)
                                .padding(6)
                        )

                    // Ikon SOS tengah (pakai SF Symbol sementara)
                   Text("SOS")
                .font(.largeTitle)
                .bold()
                .foregroundStyle(.white)
                      
                }
            }
}

#Preview {
    ContentView()
    
}
