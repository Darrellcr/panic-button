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
                onConflict: "user_id,device_token",
                ignoreDuplicates: true
            )
            .execute()
    }
    
    func registerForRemoteNotifications() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .authorized, .provisional, .ephemeral:
                print("Notification permission granted")
            default:
                print("Requesting notification permission")
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
        }
    }
}

extension Data {
    var hexString: String {
        let hexString = map { String(format: "%02.2hhx", $0) }.joined()
        return hexString
    }
}
