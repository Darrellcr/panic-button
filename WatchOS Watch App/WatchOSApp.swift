//
//  WatchOSApp.swift
//  WatchOS Watch App
//
//  Created by Calvin Christian Tjong on 18/06/25.
//

import SwiftUI

@main
struct WatchOS_Watch_AppApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onOpenURL { url in
                                    if url.host == "sos" {
                                        // Arahkan ke SOSView
                                    }
                                }
        }
    }
}
