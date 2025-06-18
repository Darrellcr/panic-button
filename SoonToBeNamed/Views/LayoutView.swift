//
//  HomeLayoutView.swift
//  SoonToBeNamed
//
//  Created by Darrell Cornelius Rivaldo on 18/06/25.
//

import SwiftUI

struct LayoutView<SOSView: View, HistoryView: View>: View {
    var sosView: SOSView
    var historyView: HistoryView
    
    init(
        @ViewBuilder sosView: () -> SOSView,
        @ViewBuilder historyView: () -> HistoryView
    ) {
        self.sosView = sosView()
        self.historyView = historyView()
    }
    
    var body: some View {
        NavigationStack {
            TabView {
                Tab("SOS", systemImage: "sos.circle") {
                    self.sosView
                }
                Tab("History", systemImage: "list.bullet.clipboard") {
                    self.historyView
                }
            }
            .navigationTitle(Text("Title"))
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    ProfilePictureView()
                }
            }
        }
    }
}

#Preview {
    LayoutView {
        VStack {
            Text("SOS")
        }
    } historyView: {
        VStack {
            Text("history")
        }
    }
}
