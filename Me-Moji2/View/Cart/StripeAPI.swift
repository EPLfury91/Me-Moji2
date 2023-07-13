//
//  ExampleSwiftUIPaymentSheet.swift
//  PaymentSheet Example
//
//  Created by David Estes on 1/15/21.
//  Copyright © 2021 stripe-ios. All rights reserved.
//

import StripePaymentSheet
import SwiftUI
import FirebaseFunctions
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import StripePaymentSheet
import Stripe
import UIKit



class firebaseFunctions: ObservableObject{
    
//    @Published var full_name : String  = ""
//    @Published var email : String  = ""
    
    //MARK: Hard coding publishable key, need to change
    let publishable_key = "pk_test_51MLoN5Ln6NfP8QkIyweffNkHamevd46IZdUFQundD5CCFD0f7IO0zUu9HjFaQ2GkycyABvxZYKzAGCdroXSr3swp00wey0QPoV"
    
//    func createStripeCustomer () {
//
//        let functions = Functions.functions()
//
//        functions.useEmulator(withHost: "192.168.1.8", port: 5001)
//
//        functions.httpsCallable("createStripeCustomer").call(["full_name" : full_name, "email" : email]) { (response, error) in
//            if let error = error {
//                print(error)
//            }
//            if let response = (response?.data as? [String: Any]) {
//                let customer_id = response["customer_id"] as! String?
//                  print(customer_id)
//                //  print(publishable_key)
//                Stripe.setDefaultPublishableKey(self.publishable_key)
//                //     profile.stripe_customer_id = customer_id!
//                let defaults = UserDefaults.standard
//                //    currentProfile = profile
//                do {
//                    //                                try self.db.collection("stripe_customers").document(emailAdd).setData(from: profile)
//                    //                                DispatchQueue.main.async {
//                    //                                    self.switchToWelcomePage()
//                    //                                }
//                } catch let error {
//                    print (error)
//                }
//            }
//        }
//    }
    
}





 
