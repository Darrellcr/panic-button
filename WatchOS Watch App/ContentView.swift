//
//  ContentView.swift
//  WatchOS Watch App
//
//  Created by Calvin Christian Tjong on 18/06/25.
//

import SwiftUI

struct ContentView: View {
    @State private var fill: CGFloat = 0.0
    @State private var isPressed = false
    @State private var isActivated = false
    @State private var timerTask: DispatchWorkItem?

    var body: some View {
        
            ZStack {
                //track circle
                Circle()
                    .stroke(Color.white.opacity(0.3),
                            style: StrokeStyle(lineWidth:30))
                
                // animation circle
                Circle()
                    .trim(from: 0, to: isActivated ? 1.0 : self.fill)
                    .stroke(Color.neonyellow1,
                            style: StrokeStyle(lineWidth:30))
                    .rotationEffect(.init(degrees: -90))
                    .animation(.linear(duration: 2), value: fill)
                
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
                            .fill(isActivated ? Color.blood3 : Color.blood0)
                            .blur(radius: 2)
                            .padding(6)
                    )
                
                // Ikon SOS tengah (pakai SF Symbol sementara)
                Text("SOS")
                    .font(.largeTitle)
                    .bold()
                    .foregroundStyle(.white)
            
            }
            .frame(width: 150, height: 180)
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { _ in
                                if !isPressed {
                                    isPressed = true
                                    withAnimation(.linear(duration: 2)) {
                                        fill = 1.0
                                    }
                                    
                                    // Start 3-second hold timer
                                    let task = DispatchWorkItem {
                                        isActivated = true
                                    }
                                    timerTask = task
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: task)
                                }
                            }
                            .onEnded { _ in
                                isPressed = false
                                fill = 0.0
                                timerTask?.cancel()
                                if !isActivated {
                                    isActivated = false
                                }
                            }
                    )
        
//            .onTapGesture {
//                
//                self.fill = 1.0
                
            

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
