//
//  NotificationService.swift
//  SoonToBeNamed
//
//  Created by Darrell Cornelius Rivaldo on 13/06/25.
//

import SwiftUI
import Supabase
import UserNotifications

final class NotificationService {
    func storeDeviceToken(session: Session, token: Data) async throws {
        let hexToken = token.hexString
        let deviceToken = DeviceToken(
            id: 0,
            userId: session.user.id,
            deviceToken: hexToken,
            deviceType: "ios"
        )
        try await supabase
            .from("device_tokens")
            .upsert(
                deviceToken,
                onConflict: "user_id,device_type",
                ignoreDuplicates: false
            )
            .execute()
    }
    
    #if os(iOS)
    func registerForRemoteNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            } else {
                print("Notification permission denied: \(error?.localizedDescription ?? "No error")")
            }
        }
    }
    #endif
    
    func sendSOSNotification(fromUserId: String) async {
        do {
            try await supabase.functions
                .invoke(
                    "send-notification",
                    options: .init(
                        method: .post,
                        body: ["elderId": fromUserId]
                    )
                )
        } catch {
            print("Error sending sos notification \(error)")
        }
    }
    
    func sendInvitationNotification(from: String, to: [String]) async {
        let body = InvitationRequestBody(userId: from, guardianIds: to)
        do {
            try await supabase.functions
                .invoke(
                    "send-invitation",
                    options: .init(
                        method: .post,
                        body: body
                    )
                )
        } catch {
            print("Error sending invitation notification: \(error)")
        }
    }
}

extension Data {
    var hexString: String {
        let hexString = map { String(format: "%02.2hhx", $0) }.joined()
        return hexString
    }
}

struct InvitationRequestBody: Encodable {
    let userId: String
    let guardianIds: [String]
}
