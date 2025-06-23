//
//  WidgetIOSLiveActivity.swift
//  WidgetIOS
//
//  Created by Michelle Michiko Tjondro on 23/06/25.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct WidgetIOSAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct WidgetIOSLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: WidgetIOSAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension WidgetIOSAttributes {
    fileprivate static var preview: WidgetIOSAttributes {
        WidgetIOSAttributes(name: "World")
    }
}

extension WidgetIOSAttributes.ContentState {
    fileprivate static var smiley: WidgetIOSAttributes.ContentState {
        WidgetIOSAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: WidgetIOSAttributes.ContentState {
         WidgetIOSAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: WidgetIOSAttributes.preview) {
   WidgetIOSLiveActivity()
} contentStates: {
    WidgetIOSAttributes.ContentState.smiley
    WidgetIOSAttributes.ContentState.starEyes
}
