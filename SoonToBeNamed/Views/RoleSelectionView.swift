//
//  RoleSelectionView.swift
//  SoonToBeNamed
//
//  Created by Darrell Cornelius Rivaldo on 17/06/25.
//

import SwiftUI

struct RoleSelectionView: View {
    @EnvironmentObject var authService: AuthService
    private let profileService = ProfileService()
    
    var body: some View {
        NavigationStack{
            ZStack{
                LoginBackgroundView()
                VStack{
                    Text("Which one are you?")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                        .padding(30)
                    
                    Button {
                        Task {
                            if let user = authService.user {
                                await updateRole(
                                    uuid: user.id.uuidString,
                                    role: .elderly
                                )
                            }
                        }
                    } label: {
                        Text("Elderly")
                            .font(.title3)
                            .bold(true)
                            .foregroundStyle(.black)
                            .frame(width: 228)
                            .padding(.vertical, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(.white)
                            )
                    }
                    .padding(.bottom, 24)
                    
                    Button {
                        Task {
                            if let user = authService.user {
                                await updateRole(
                                    uuid: user.id.uuidString,
                                    role: .guardian
                                )
                            }
                        }
                    } label: {
                        Text("Guardian")
                            .font(.title3)
                            .bold(true)
                            .foregroundStyle(.black)
                            .frame(width: 228)
                            .padding(.vertical, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(.white)
                            )
                    }
                }
            }
        }
    }
    
    func updateRole(uuid: String, role: Role) async {
        let success = await profileService.updateRole(uuid: uuid, role: role)
        if success {
            await MainActor.run {
                authService.role = role                
            }
        }
    }
}

#Preview {
    RoleSelectionView()
}
