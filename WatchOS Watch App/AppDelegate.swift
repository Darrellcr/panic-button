//
//  AppDelegate.swift
//  SafeTap Watch App
//
//  Created by Darrell Cornelius Rivaldo on 18/06/25.
//

import WatchKit
import WatchConnectivity

class AppDelegate: NSObject, WKApplicationDelegate {
    private var activationStateObservation: NSKeyValueObservation?
    private var hasContentPendingObservation: NSKeyValueObservation?
    private var wcBackgroundTasks = [WKWatchConnectivityRefreshBackgroundTask]()
    
    override init() {
        super.init()
        assert(WCSession.isSupported(), "This sample requires a platform supporting Watch Connectivity!")
        
        activationStateObservation = WCSession.default.observe(\.activationState) { _, _ in
            DispatchQueue.main.async {
                self.completeBackgroundTasks()
            }
        }
        hasContentPendingObservation = WCSession.default.observe(\.hasContentPending) { _, _ in
            DispatchQueue.main.async {
                self.completeBackgroundTasks()
            }
        }
        
        WCSession.default.delegate = self
        WCSession.default.activate()
    }
    
    func completeBackgroundTasks() {
        guard !wcBackgroundTasks.isEmpty else { return }

        guard WCSession.default.activationState == .activated,
            WCSession.default.hasContentPending == false else { return }
        
        wcBackgroundTasks.forEach { $0.setTaskCompletedWithSnapshot(false) }

        let date = Date(timeIntervalSinceNow: 1)
        WKApplication.shared().scheduleSnapshotRefresh(withPreferredDate: date, userInfo: nil) { error in
            
            if let error = error {
                print("scheduleSnapshotRefresh error: \(error)!")
            }
        }
        wcBackgroundTasks.removeAll()
    }
}

extension AppDelegate: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: (any Error)?) {

    }
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        print("didReceiveApplicationContext")
        NotificationCenter.default.post(
            name: .authDidChange,
            object: applicationContext
        )
    }
    
    func handle(_ backgroundTasks: Set<WKRefreshBackgroundTask>) {
        for task in backgroundTasks {
            if let wcTask = task as? WKWatchConnectivityRefreshBackgroundTask {
                wcBackgroundTasks.append(wcTask)
            } else {
                task.setTaskCompletedWithSnapshot(false)
            }
        }
        completeBackgroundTasks()
    }
}

extension Notification.Name {
    static let authDidChange = Notification.Name("authDidChange")
}
