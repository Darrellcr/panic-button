//
//  RoleSelectionView.swift
//  SoonToBeNamed
//
//  Created by Darrell Cornelius Rivaldo on 17/06/25.
//

import SwiftUI

struct RoleSelectionView: View {
    var body: some View {
        NavigationStack{
            ZStack{
                LoginBackground()
                VStack{
                    Text("Which one are you?")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                        .padding(30)
                    NavigationLink(destination: ElderlyView()){
                        Text("Elderly")
                            .font(.body)
                            .foregroundStyle(.black)
                            .frame(width: 228, height: 44)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(.white)
                                
                            )
                            .padding(.bottom, 30)
                    }
                    
                    NavigationLink(destination: GuardianView()){
                        Text("Guardian")
                            .font(.body)
                            .foregroundStyle(.black)
                            .frame(width: 228, height: 44)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(.white)
                            )
                    }
                    
                }
            }
        }
        
        
        
    }
}

#Preview {
    RoleSelectionView()
}
