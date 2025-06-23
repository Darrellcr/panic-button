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
//                    .foregroundStyle(.white)
                    .offset(x: -10)
            }
//            .padding(.horizontal,10)
           
        }
//        ZStack{
//            Capsule()
//                .fill(.red)
//            HStack{
//                Image("logo_transparent")
//                    .resizable()
//                    .scaledToFit()
//                    .frame(width: 40)
//                Text("Dua")
//            }
//        }
        .widgetURL(URL(string: "myapp://sos"))
        .containerBackground(.fill.tertiary, for: .widget)
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
