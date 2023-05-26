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



