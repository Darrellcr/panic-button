//
//  AppDelegate.swift
//  SoonToBeNamed
//
//  Created by Darrell Cornelius Rivaldo on 13/06/25.
//

import Foundation
import UIKit
import UserNotifications
import WatchConnectivity
import CoreLocation

final class AppDelegate: NSObject, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        
        configureNotificationCategories()
        setupWatchConnectivity()
        
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        UNUserNotificationCenter.current().setBadgeCount(0)
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
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
                print("Successfully stored device token")
            } catch {
                print("Failed to store device token: \(error)")
            }
        }
    }
    
    func configureNotificationCategories() {
        print("notification category configured")
        let acceptAction = UNNotificationAction(identifier: "ACCEPT_ACTION",
              title: "Accept",
              options: [])
        let declineAction = UNNotificationAction(identifier: "DECLINE_ACTION",
              title: "Decline",
              options: [])
        // Define the notification type
        let meetingInviteCategory =
              UNNotificationCategory(identifier: "invitation",
              actions: [acceptAction, declineAction],
              intentIdentifiers: [],
              hiddenPreviewsBodyPlaceholder: "",
              options: .customDismissAction)
        // Register the notification type.
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.setNotificationCategories([meetingInviteCategory])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        if response.notification.request.content.categoryIdentifier == "invitation" {
            let userInfo = response.notification.request.content.userInfo
            let userId = userInfo["userId"] as! String
            let userFullName = userInfo["userFullName"] as! String
            let profile = Profile(
                id: UUID(uuidString: userId)!,
                fullName: userFullName,
                email: nil
            )
            
            switch response.actionIdentifier {
            case "ACCEPT_ACTION":
                break
            case UNNotificationDefaultActionIdentifier:
                NotificationCenter.default.post(name: .invitationReceived, object: profile)
            default:
                break
            }
        } else if response.notification.request.content.categoryIdentifier == "sos" {
            print("sos received")
        }
        
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        if notification.request.content.categoryIdentifier == "invitation" {
            let userInfo = notification.request.content.userInfo
            let userId = userInfo["userId"] as! String
            let userFullName = userInfo["userFullName"] as! String
            let profile = Profile(
                id: UUID(uuidString: userId)!,
                fullName: userFullName,
                email: nil
            )
            NotificationCenter.default.post(name: .invitationReceived, object: profile)
        } else if notification.request.content.categoryIdentifier == "sos" {
            print("sos received")
        }
        
        
        completionHandler([.sound, .banner])
    }
}

extension AppDelegate: WCSessionDelegate {
    func setupWatchConnectivity() {
        guard WCSession.isSupported() else { return }
        WCSession.default.delegate = self
        WCSession.default.activate()
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: (any Error)?) {
        print(activationState.rawValue)
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("Session did become inactive")
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        print("Session did deactivate")
        session.activate()
    }
    
    func sessionReachabilityDidChange(_ session: WCSession) {
        print("Reachable: \(WCSession.default.isReachable)")
    }
}

extension Notification.Name {
    static let invitationReceived = Notification.Name("invitationReceived")
    static let emergencyReceived = Notification.Name("emergencyReceived")
}
