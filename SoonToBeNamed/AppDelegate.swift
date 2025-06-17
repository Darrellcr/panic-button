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
    var deviceToken: Data?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        
        return true
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        self.deviceToken = deviceToken
    }
}
