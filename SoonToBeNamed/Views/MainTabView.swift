//
//  MainTabView.swift
//  SoonToBeNamed
//
//  Created by Calvin Christian Tjong on 20/06/25.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            GuardianView()
                .tabItem {
                    Image(systemName: "sos.circle.fill")
                    Text("SOS")
                }
            HistoryView()
                .tabItem {
                    Image(systemName: "list.clipboard")
                    Text("History")
                }
        }
    }
}

#Preview {
    MainTabView()
}