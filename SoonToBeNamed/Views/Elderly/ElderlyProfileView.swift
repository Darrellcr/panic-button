//
//  ElderlyProfileView.swift
//  SafeTap
//
//  Created by Darrell Cornelius Rivaldo on 20/06/25.
//

import SwiftUI

struct ElderlyProfileView: View {
    @EnvironmentObject var authService: AuthService
    private let guardianService = GuardianService()
    @State var showAddGuardianSheet = false
    @State var confirmedGuardians: [Profile] = []
    let profile: Profile?
    
    var body: some View {
        VStack {
            VStack {
                ProfilePictureView(size: 140)
                Text(profile?.fullName ?? "Full Name")
                    .font(.title)
                    .bold()
                Text(verbatim: profile?.email ?? "email@example.com")
                    .font(.title3)
            }
            
            Divider()
                .safeAreaPadding()
            
            List {
                Section {
                    if !confirmedGuardians.isEmpty {
                        ForEach(confirmedGuardians, id: \.self) { confirmedGuardian in
                            ContactRowView(
                                fullName: confirmedGuardian.fullName!, email: confirmedGuardian.email!
                            )
                            .listRowBackground(Color.secondary.opacity(0.2))
                        }
                        .onDelete(perform: { offsets in
                            print(offsets)
                        })
                    } else {
                        Text("Start adding your guardians")
                            .frame(maxWidth: .infinity, minHeight: 150, alignment: .center)
                    }
                } header: {
                    Text("Emergency Contact")
                        .foregroundStyle(.black)
                        .listRowInsets(EdgeInsets())
                        .font(.headline)
                        .foregroundStyle(.black)
                        .bold()
                }
            }
            .scrollContentBackground(.hidden)
            .frame(maxHeight: 300)
            .safeAreaPadding()
            .padding(.bottom, 20)
            .refreshable {
                Task {
                    let guardians = await guardianService.getConfirmedGuardiansOfUser(userId: authService.user!.id.uuidString)
                    await MainActor.run {
                        confirmedGuardians = guardians
                    }
                }
            }
            
            Spacer()
            
            Button {
                showAddGuardianSheet = true
            } label: {
                Text("Add Guardian")
                    .font(.title3)
                    .foregroundStyle(.white)
                    .bold()
                    .padding(.vertical, 6)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .backgroundStyle(.backColor1)
            .padding(.bottom, 50)
            .padding(.horizontal, 20)
        }
        .navigationTitle("Profile")
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
}

#Preview {
    ElderlyProfileView(
        profile: Profile(id: UUID(), fullName: "Darrell Cornelius R", email: "email@example.com")
    )
}
