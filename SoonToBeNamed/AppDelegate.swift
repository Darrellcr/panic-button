//
//  AppDelegate.swift
//  SoonToBeNamed
//
//  Created by Darrell Cornelius Rivaldo on 13/06/25.
//

import Foundation
import UIKit
import UserNotifications

final class AppDelegate: NSObject, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        
        return true
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenString = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        
        Task {
            do {
                let session = try await supabase.auth.session
                let userId = session.user.id.uuidString
                
                try await supabase
                    .from("device_tokens")
                    .insert([
                        "user_id": userId,
                        "device_token": tokenString,
                        "device_type": "ios"
                    ])
                    .execute()
            } catch {
                print("Failed to store device token: \(error)")
            }
        }
    }
}
