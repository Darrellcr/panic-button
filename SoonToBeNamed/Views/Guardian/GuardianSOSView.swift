//
//  GuardianSOSView.swift
//  SoonToBeNamed
//
//  Created by Darrell Cornelius Rivaldo on 18/06/25.
//

import SwiftUI

struct GuardianSOSView: View {
    var emergencyExist: Bool = false
    var location: Location?
    
    var body: some View {
        Group {
            if !emergencyExist {
                Text("There is no Emergency")
            } else {
                
            }
        }
        .task {
            Task {
                
            }
        }
    }
}

#Preview {
    GuardianSOSView()
}
