////
////  GuardianView.swift
////  SoonToBeNamed
////
////  Created by Calvin Christian Tjong on 17/06/25.
////
//
//
//
//import SwiftUI
//
//struct GuardianView: View {
//    @EnvironmentObject var authService: AuthService
//    var emptyState = false
//    @State var buttonClick = false
//    @State var textField:String = ""
//    var body: some View {
//        NavigationStack{
//            ZStack{
//                if(emptyState){
//                    EmptyStateView
//                }
//                else{
//                    EmergencyView
//                }
//            }
//            .navigationTitle(Text("SOS"))
////            .navigationBarTitleDisplayMode(.large)
////            .font(.largeTitle)
//        }
//    }
//    
//    var EmptyStateView: some View {
//        VStack {
////            Spacer()
//            Text("Your loved one is safe")
//                .font(.largeTitle)
//                .bold()
//        }
//    }
//    var EmergencyView: some View {
//        VStack{
//            ZStack{
//                Circle()
//                    .fill(Color.red)
//                    .frame(width: 350, height: 350)
//                Text("Ini tempat untuk MAPnya")
//                    .font(.title)
//                    .foregroundColor(.white)
//                
//            }
//            Button(action: {
//                // Aksi ketika tombol ditekan
//                buttonClick.toggle()
//            }) {
//                Text("End Emergency")
//                    .font(.headline)
//                    .foregroundStyle(.backColor2)
//                    .frame(width: 350, height: 50) // Ukuran tombol
//                    .background(
//                        RoundedRectangle(cornerRadius: 20)
//                            .fill(Color.white) // Warna latar tombol
//                    )
//                    .overlay(
//                        RoundedRectangle(cornerRadius: 20)
//                            .stroke(Color.backColor2, lineWidth: 2) // Garis tepi
//                    )
//            }
//            
//        }
//        .alert("Please insert the reason elderly click the SOS", isPresented: $buttonClick) {
////            TextField("Reason", value: $textField, format:.)
//            TextField("", text: $textField)
//            Button("Cancel", role: .cancel){
//                textField = ""
//            }
//            Button("Done"){
//                print(textField)
//                textField = ""
//            }.disabled(textField.isEmpty)
//        }
//       
//        
//    }
//}
//#Preview {
//    GuardianView()
//}

import SwiftUI

struct GuardianView: View {
    @State private var showAlert = false
    @State private var textField = ""
    @State private var timer: Timer? = nil
    
    var body: some View {
        Button("Trigger SOS Alert") {
            showAlert = true
            startAutoDismissTimer()
        }
        .alert("Please insert the reason elderly click the SOS", isPresented: $showAlert) {
            TextField("", text: $textField)
            Button("Cancel", role: .cancel) {
                textField = ""
                invalidateTimer()
            }
            Button("Done") {
                print(textField)
                textField = ""
                invalidateTimer()
            }.disabled(textField.isEmpty)
        }
    }
    
    // MARK: - Timer logic
    func startAutoDismissTimer() {
        invalidateTimer()
        timer = Timer.scheduledTimer(withTimeInterval: 120, repeats: false) { _ in
            showAlert = false
            textField = ""
            print("Dismissed due to timeout")
        }
    }
    
    func invalidateTimer() {
        timer?.invalidate()
        timer = nil
    }
}
