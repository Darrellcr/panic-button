//
//  AddGuardianSheet.swift
//  SafeTap
//
//  Created by Darrell Cornelius Rivaldo on 19/06/25.
//

import SwiftUI

struct AddGuardianSheetView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var authService: AuthService
    let guardianService = GuardianService()
    let notificationService = NotificationService()
    @State var searchText: String = ""
    @State var guardians: [Profile] = []
    @State var selectedGuardians = Set<UUID>()
    var filteredGuardians: [Profile] {
        if searchText.isEmpty {
            return guardians
        } else {
            return guardians.filter { guardian in
                return guardian.fullName!.localizedStandardContains(searchText) || guardian.email!.localizedStandardContains(searchText)
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                List(filteredGuardians, selection: $selectedGuardians) { guardian in
                    ContactRowView(
                        fullName: guardian.fullName!, email: guardian.email!
                    )
                    
                }
                .environment(\.editMode, .constant(.active))
                .searchable(text: $searchText)
            }
            .navigationTitle("Add Guardian")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        if !selectedGuardians.isEmpty {
                            let selectedIds = Array(selectedGuardians).map(\.uuidString)
                            Task {
                                let elderId = authService.user!.id.uuidString
                                await guardianService.addGuardians(userId: elderId, guardianIds: selectedIds)
                                await notificationService.sendInvitationNotification(from: elderId, to: selectedIds)
                            }
                        }
                        dismiss()
                        
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .task {
                Task {
                    let allGuardians = await guardianService.getAllGuardians()
//                    var confirmedGuardians = (await guardianService.getConfirmedGuardiansOfUser(userId: authService.user!.id.uuidString))
//                        .map(\.guardianId)
                    let confirmedGuardians = (await guardianService.getConfirmedGuardiansOfUser(userId: authService.user!.id.uuidString))
                        .map(\.id)
                    guardians = allGuardians.filter { !confirmedGuardians.contains($0.id) }
                }
            }
        }
    }
}

#Preview {
    AddGuardianSheetView(
//        guardians: [
//            Profile(id: UUID(), fullName: "Darrell Cornelius Rivaldo", email: "a@a.com"),
//            Profile(id: UUID(), fullName: "Calvin Christian Tjong", email: "a@a.com"),
//            Profile(id: UUID(), fullName: "Michelle Michiko", email: "z@a.com")
//        ],
//        selectedGuardians: .constant(Set<UUID>())
    )
}
