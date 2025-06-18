//
//  LoginBackgroundView.swift
//  SoonToBeNamed
//
//  Created by Darrell Cornelius Rivaldo on 17/06/25.
//

import SwiftUI

struct LoginBackgroundView: View {
    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [.backColor1,.backColor2]),
            startPoint: .leading,
            endPoint: .trailing
        )
        .ignoresSafeArea()
    }
    
}

#Preview {
    LoginBackgroundView()
}
