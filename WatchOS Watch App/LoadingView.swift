//
//  LoadingView.swift
//  SafeTap Watch App
//
//  Created by Darrell Cornelius Rivaldo on 22/06/25.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        VStack(spacing: 16) {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
                .scaleEffect(2)
        }
    }
}

#Preview {
    LoadingView()
}
