//
//  Me_Moji2App.swift
//  Me-Moji2
//
//  Created by Brett Tracey on 11/28/22.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth
import StripePaymentSheet
import FirebaseFunctions
import Stripe


class AppDelegate: NSObject, UIApplicationDelegate {
    
    lazy var functions = Functions.functions()
    
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
      

    return true
  }
}

@main
struct Me_Moji2App: App {
    
    // register app delegate for Firebase setup
      @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            LaunchView()
                .environmentObject(ContentModel())
        }
    }
}
