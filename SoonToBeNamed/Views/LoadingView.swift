//
//  LoadingView.swift
//  SoonToBeNamed
//
//  Created by Darrell Cornelius Rivaldo on 17/06/25.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        ZStack {
            LoginBackgroundView()
            VStack(spacing: 16) {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(2)
            }
        }
    }
}

#Preview {
    LoadingView()
}
