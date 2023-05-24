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
    case LoginIn = 0
    case Customize = 1
}

struct LaunchView: View {
    //@ObservedObject var model1 : Users
    @EnvironmentObject var model: ContentModel
    @State var screen : Screen = .LoginIn

    var body: some View {
        NavigationView{
            VStack {
                
                switch screen {
                    case .LoginIn: LoginView(currentScreen: $screen)
                    case .Customize: CustomizationView(currentScreen: $screen)
                    default: CustomizationView(currentScreen: $screen)
                }
           
                
//
//                if AuthViewModel.isLoggedIn() != false {
//                    CustomizationView()
//                } else {
//                    LoginView()
//
//                }
                
            }
            .padding()
        }
        
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        LaunchView()
//    }
//}
