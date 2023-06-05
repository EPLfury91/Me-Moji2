//
//  UIKitToSwiftUIModel.swift
//  Me-Moji2
//
//  Created by Brett Tracey on 4/27/23.
//

import Foundation
import SwiftUI
import FirebaseAuth
import Firebase
import StripePaymentSheet
import Stripe
import FirebaseFirestore
import FBSDKLoginKit
import FBSDKCoreKit
import UIKit
import SwiftUI

class AuthViewModel {
    static func isLoggedIn() -> Bool {
        return Auth.auth().currentUser != nil
    }
    
    static func currentUser() -> String {
        return Auth.auth().currentUser?.uid ?? ""
    }
}

final class AuthViewModel2: ObservableObject {
    var user: User? {
        didSet {
            objectWillChange.send()
        }
    }
    
    func listenToAuthState() {
        Auth.auth().addStateDidChangeListener { [weak self] _, user in
            guard let self = self else {
                return
            }
            self.user = user
        }
    }
    
    func signUp(
           emailAddress: String,
           password: String
       ) {
           Auth.auth().createUser(withEmail: emailAddress, password: password) { result, error in
               if let error = error {
                   print("an error occured: \(error.localizedDescription)")
                   return
               }
           }
       }
       
       func signOut() {
           do {
               try Auth.auth().signOut()
           } catch let signOutError as NSError {
               print("Error signing out: %@", signOutError)
           }
       }
   
}



