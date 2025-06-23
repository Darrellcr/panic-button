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
    func placeholder(in context: Context) -> WidgetIOSEntry {
        WidgetIOSEntry(date: Date())
    }
    
    func getSnapshot(in context: Context, completion: @escaping (WidgetIOSEntry) -> Void) {
        let entry = WidgetIOSEntry(date: Date())
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<WidgetIOSEntry>) -> Void) {
        let entry = WidgetIOSEntry(date: Date())
        let timeline = Timeline(entries: [entry], policy: .never)
        completion(timeline)
    }
}

struct WidgetIOSEntry: TimelineEntry {
    let date: Date
}


struct WidgetIOSEntryView : View {
    var entry: Provider.Entry
    
    var body: some View {
        ZStack {
            Capsule()
                .fill(.blood0)
            HStack{
                Image("logo_transparent")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .offset(x: 0, y: 2)
                Text("SOS")
                    .font(.title)
                    .bold()
                    .offset(x: -10)
            }
            .widgetURL(URL(string: "myapp://sos"))
            .containerBackground(.fill.tertiary, for: .widget)
        }
    }
}
//@main
struct WidgetIOS: Widget {
    let kind: String = "WatchOS"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            WidgetIOSEntryView(entry: entry)
        }
        .supportedFamilies([.accessoryRectangular])
        .configurationDisplayName("SOS Button")
        .description("Tap to open SOS screen.")
    }
}

#Preview(as: .accessoryRectangular) {
    WidgetIOS()
} timeline:{
    WidgetIOSEntry(date: Date())
}
