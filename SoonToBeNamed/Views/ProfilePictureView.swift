//
//  ProfilePictureView.swift
//  SoonToBeNamed
//
//  Created by Darrell Cornelius Rivaldo on 18/06/25.
//

import SwiftUI

struct ProfilePictureView: View {
    var size: CGFloat
    
    init(size: CGFloat = 40) {
        self.size = size
    }
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color(.systemGray5)) // subtle highlight color
                .frame(width: size, height: size)
                .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)

            Image(systemName: "person.fill")
                .foregroundColor(.primary)
                .font(.system(size: size/2, weight: .medium))
        }
        .padding(.horizontal)
    }
}

#Preview {
    ProfilePictureView()
}
