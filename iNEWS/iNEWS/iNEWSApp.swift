//
//  iNEWSApp.swift
//  iNEWS
//


import SwiftUI
import FirebaseCore

@main
struct XCANewsApp: App {
    
    @StateObject var articleBookmarkVM = ArticleBookmarkViewModel.shared
    @AppStorage("uid") var userID: String = ""
    
    init(){
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            if userID == ""{
                AuthView()
            } else {
                ContentView().environmentObject(articleBookmarkVM)
            }
               
        }
    }
}
