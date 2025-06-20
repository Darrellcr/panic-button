//
//  OnboardingAddGuardianView.swift
//  SoonToBeNamed
//
//  Created by Darrell Cornelius Rivaldo on 18/06/25.
//

import SwiftUI

struct OnboardingAddGuardianView: View {
    @EnvironmentObject var authService: AuthService
    private let profileService = ProfileService()
    private let guardianService = GuardianService()
    @State var showAddGuardianSheet: Bool = false
    @State var confirmedGuardians: [Profile] = []
    
    var body: some View {
        ZStack {
            LoginBackgroundView()
                .ignoresSafeArea(edges: .all)
            VStack {
                Text("Add your guardian")
                    .foregroundStyle(.white)
                    .font(.largeTitle)
                    .bold()
                VStack {
                    
                    GroupBox {
                        List {
                            Section {
                                if !confirmedGuardians.isEmpty {
                                    ForEach(confirmedGuardians, id: \.self) { confirmedGuardian in
                                        ContactRowView(
                                            fullName: confirmedGuardian.fullName!, email: confirmedGuardian.email!
                                        )
                                        
                                    }
                                    .onDelete(perform: { offsets in
                                        print(offsets)
                                    })
                                } else {
                                    Text("Start adding your guardians")
                                        .frame(maxWidth: .infinity, minHeight: 150, alignment: .center)
                                }
                                
                            } header: {
                                Text("Guardian Contact")
                                    .foregroundStyle(.white)
                                    .listRowInsets(EdgeInsets())
                                    .font(.headline)
                                    .foregroundStyle(.black)
                                    .bold()
                            }
                            
                        }
                        .scrollContentBackground(.hidden)
                        .refreshable {
                            Task {
                                let guardians = await guardianService.getConfirmedGuardiansOfUser(userId: authService.user!.id.uuidString)
                                await MainActor.run {
                                    confirmedGuardians = guardians
                                }
                            }
                        }
                        
                        
                        VStack {
                            Button {
                                showAddGuardianSheet = true
                            } label: {
                                Text("Add Guardian")
                                    .font(.title3)
                                    .foregroundStyle(.black)
                                    .bold()
                                    .padding(.vertical, 6)
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(Color.background)
                            .padding(.bottom, 24)
                            .padding(.horizontal, 20)
                            
                            if confirmedGuardians.isEmpty {
                                Button {
                                    Task {
                                        await finishOnboarding()
                                    }
                                } label: {
                                    Text("Skip this for now")
                                        .foregroundStyle(.white)
                                        .underline()
                                }
                            } else {
                                Button {
                                    Task {
                                        await finishOnboarding()
                                    }
                                } label: {
                                    Text("Finish")
                                        .font(.title3)
                                        .foregroundStyle(.white)
                                        .bold()
                                        .padding(.vertical, 6)
                                        .frame(maxWidth: .infinity)
                                }
                                .buttonStyle(.borderedProminent)
                                .buttonStyle(.borderedProminent)
                                .padding(.horizontal, 20)
                            }
                        }
                        .frame(alignment: .topLeading)
                    }
                    .frame(maxHeight: 600)
                    .backgroundStyle(LinearGradient(
                        gradient: Gradient(colors: [.backColor1,.backColor2]),
                        startPoint: .leading,
                        endPoint: .trailing
                    ))
                }
                .frame(maxHeight: .infinity)
            }
        }
        .sheet(isPresented: $showAddGuardianSheet) {
            AddGuardianSheetView()
        }
        .task {
            Task {
                let guardians = await guardianService.getConfirmedGuardiansOfUser(userId: authService.user!.id.uuidString)
                await MainActor.run {
                    confirmedGuardians = guardians
                }
            }
        }
    }
    
    private func finishOnboarding() async {
        guard let uid = authService.user?.id.uuidString else { return }
        let success = await profileService.finishOnboarding(uuid: uid)
        guard success else { return }
        await MainActor.run {
            authService.onboarded = true
        }
    }
}

#Preview {
    OnboardingAddGuardianView()
}
