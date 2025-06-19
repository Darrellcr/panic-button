//
//  WatchOSView.swift
//  SoonToBeNamed
//
//  Created by Calvin Christian Tjong on 19/06/25.
//

import SwiftUI
import WidgetKit

struct WatchOSWidgetView: View {
    var body: some View {
        ZStack {
            Capsule()
                .fill(.color)
            HStack{
                Image("logo_transparent")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 10, height: 10)
                Text("SOS")
                    .font(.title)
                    .bold()
                    .foregroundStyle(.white)
            }
            
        }
        .widgetURL(URL(string: "myapp://sos"))
        .containerBackground(.fill.tertiary, for: .widget)

    }
}

#Preview {
    
}
