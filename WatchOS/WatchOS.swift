//
//  WatchOS.swift
//  WatchOS
//
//  Created by Calvin Christian Tjong on 19/06/25.
//

import WidgetKit
import SwiftUI
import AppIntents

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> WatchOSEntry {
        WatchOSEntry(date: Date())
    }
    
    func getSnapshot(in context: Context, completion: @escaping (WatchOSEntry) -> Void) {
        let entry = WatchOSEntry(date: Date())
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<WatchOSEntry>) -> Void) {
        let entry = WatchOSEntry(date: Date())
        let timeline = Timeline(entries: [entry], policy: .never)
        completion(timeline)
    }
}

struct WatchOSEntry: TimelineEntry {
    let date: Date
}


struct WatchOSEntryView : View {
    var entry: Provider.Entry
    
    var body: some View {
        WatchOSWidgetView()
    }
}

@main
struct WatchOS: Widget {
    let kind: String = "WatchOS"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            WatchOSEntryView(entry: entry)
        }
        .supportedFamilies([.accessoryRectangular])
        .configurationDisplayName("SOS Button")
        .description("Tap to open SOS screen.")
    }
}

#Preview(as: .accessoryRectangular) {
    WatchOS()
} timeline:{
    WatchOSEntry(date: Date())
}
