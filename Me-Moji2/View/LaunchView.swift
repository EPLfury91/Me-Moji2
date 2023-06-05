//
//  ContentView.swift
//  Me-Moji2
//
//  Created by Brett Tracey on 11/28/22.
//

import SwiftUI
import FBSDKLoginKit
import FBSDKCoreKit
import FirebaseAuth
import FirebaseFirestore

enum Screen: Int {
    case Login = 0
    case MainbodyView = 1
}

struct LaunchView: View {
    @EnvironmentObject var model: ContentModel
    @State var screen : Screen = .Login

    var body: some View {
        NavigationView{
            VStack {
                
                if model.user != nil {
                    MainBodyView(currentScreen: $screen)
                } else {
                    LoginView(currentScreen: $screen)
                }
                
//                switch screen {
//                    case .Login: LoginView(currentScreen: $screen)
//                    case .MainbodyView: MainBodyView(currentScreen: $screen)
//                }
            }
            .onAppear{
                model.listenToAuthState()}
            .padding()
        }
        
        
    }
}
