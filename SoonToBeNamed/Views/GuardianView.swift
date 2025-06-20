////
////  GuardianView.swift
////  SoonToBeNamed
////
////  Created by Calvin Christian Tjong on 17/06/25.
////
//
//import SwiftUI
//
//struct GuardianView: View {
//    @EnvironmentObject var authService: AuthService
//    var emptyState = true
//    var body: some View {
//        TabView{
//            VStack{
//                Image(systemName: "sos.circle.fill")
//                    .resizable()
//                    .frame(width: 100, height: 100)
//                Text("SOS")
//                    .font(.headline)
//
//            }
//            .tabItem {
//                           Image(systemName: "sos.circle")
//                           Text("SOS")
//            VStack{
//                Image(systemName: "list.clipboard")
//                    .resizable()
//                    .frame(width: 100, height: 100)
//                Text("History")
//                    .font(.headline)
//            }
//        }
//        if(emptyState){
//            EmptyStateView
//        }
//        else{
//
//        }
//        Button("Logout") {
//            Task {
//                do {
//                    try await authService.logout()
//                }
//            }
//        }
//    }
//}
//
//var EmptyStateView: some View {
//    Text("Your loved one is safe")
//        .font(.largeTitle)
//        .bold(true)
//}
//
//var EmergencyView: some View {
//    ZStack {
//        Rectangle().fill(Color.red)
//            .frame(width: 300, height: 300)
//
//    }
//}
//
//#Preview {
//    GuardianView()
//}


import SwiftUI

struct GuardianView: View {
    @EnvironmentObject var authService: AuthService
    var emptyState = false
    @State var buttonClick = false
    @State var textField:String = ""
    var body: some View {
        ZStack{
            
            TabView {
                
                Tab("SOS", systemImage: "sos.circle.fill"){
                    
                }
                Tab("History", systemImage: "list.clipboard"){
                    
                }
                
            }
            if(emptyState){
                EmptyStateView
            }
            else{
                EmergencyView
            }
        }
        
    }
    
    var EmptyStateView: some View {
        VStack {
            Spacer()
            Text("Your loved one is safe")
                .font(.largeTitle)
                .bold()
        }
    }
    var EmergencyView: some View {
        VStack{
            ZStack{
                Circle()
                    .fill(Color.red)
                    .frame(width: 350, height: 350)
                Text("Ini tempat untuk MAPnya")
                    .font(.title)
                    .foregroundColor(.white)
                
            }
            Button(action: {
                // Aksi ketika tombol ditekan
                buttonClick.toggle()
            }) {
                Text("End Emergency")
                    .font(.headline)
                    .foregroundStyle(.backColor2)
                    .frame(width: 350, height: 50) // Ukuran tombol
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white) // Warna latar tombol
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.backColor2, lineWidth: 2) // Garis tepi
                    )
            }
            
        }
        .alert("Please insert the reason elderly click the SOS", isPresented: $buttonClick) {
//            TextField("Reason", value: $textField, format:.)
            TextField("", text: $textField)
            Button("Cancel", role: .cancel){
                textField = ""
            }
            Button("Done"){
                print(textField)
                textField = ""
            }.disabled(textField.isEmpty)
        }
        
    }
}
#Preview {
    GuardianView()
}
