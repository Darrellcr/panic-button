//
//  SOSButtonView.swift
//  SafeTap Watch App
//
//  Created by Darrell Cornelius Rivaldo on 19/06/25.
//

import SwiftUI

struct SOSButtonView: View {
    @State private var fill: CGFloat = 0.0
    @State private var isPressed = false
    @State private var isActivated = false
    @State private var timerTask: DispatchWorkItem?
    let size: CGFloat
    private let onActivate: () -> Void
    private let onDeactivate: () -> Void
    
    init(size: CGFloat = 150, onActivate: @escaping () -> Void, onDeactivate: @escaping () -> Void) {
        self.size = size
        self.onActivate = onActivate
        self.onDeactivate = onDeactivate
    }
    
    var body: some View {
        ZStack {
            // Full screen red background when activated
            if isActivated {
                Color.blood0
                    .ignoresSafeArea()
                    .transition(.opacity)
                
                Text("SOS")
                    .font(.system(size: 70, weight: .black))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .center)
                
            } else {
                // Normal UI
                VStack(spacing: 2) {
                    ZStack {
                        // Background track circle
                        Circle()
                            .stroke(Color.white.opacity(0.3),
                                    style: StrokeStyle(lineWidth:30))
                        
                        // Animated fill circle
                        Circle()
                            .trim(from: 0, to: self.fill)
                            .stroke(Color.neonyellow1,
                                    style: StrokeStyle(lineWidth:30))
                            .rotationEffect(.degrees(-90))
                            .animation(.linear(duration: 2), value: fill)
                        
                        // Button appearance
                        Circle()
                            .fill(Color.black)
                            .frame(width: self.size, height: self.size)
                            .shadow(color: .black, radius: 10)
                            .overlay(
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
                                Circle()
                                    .fill(isActivated ? Color.blood3 : Color.blood0)
                                    .blur(radius: 2)
                                    .padding(6)
                            )
                        
                        // SOS text
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
                                    
                                    let task = DispatchWorkItem {
                                        withAnimation {
                                            isActivated = true
                                            onActivate()
                                        }
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
                    
                    // Logo & Name
                    HStack {
                        Image("logo_transparent")
                            .resizable()
                            .clipShape(Circle())
                            .frame(width: 40, height: 40)
                        Text("SafeTap")
                    }
                    .frame(width: 200)
                    .offset(x:-10)
                    .padding(.bottom, 10)
                }
                .padding(.top, 10)
            }
        }
        .animation(.easeInOut, value: isActivated)
        .onChange(of: isActivated) { newValue in
            if isActivated {
                _ = Timer.scheduledTimer(withTimeInterval: 5, repeats: false, block: { _ in
                    isActivated = false
                    fill = 0.0
                    onDeactivate()
                })
            }
        }
    }
}


#Preview {
    SOSButtonView() {
        
    } onDeactivate: {
        
    }
}
