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
import FBSDKCoreKit
import UIKit



//class AppDelegate: UIResponder,NSObject, UIApplicationDelegate {

//NSObject,
//@UIApplicationMain
class AppDelegate: UIResponder,   UIApplicationDelegate {
    lazy var functions = Functions.functions()
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        FirebaseApp.configure()
        ApplicationDelegate.shared.application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )
        return true
    }
  
   
    func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey : Any] = [:]
    ) -> Bool {
        ApplicationDelegate.shared.application(
            app,
            open: url,
            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
            annotation: options[UIApplication.OpenURLOptionsKey.annotation]
        )
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
