//
//  ExampleAdditions.swift
//  PaymentSheet Example
//
//  Created by David Estes on 1/15/21.
//  Copyright © 2021 stripe-ios. All rights reserved.
//

import StripePaymentSheet
import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import Firebase
import UIKit
import Foundation

@_spi(STP) import StripeCore
@_spi(STP) import StripeUICore

//MARK: THIS IS ONE we are using
class MyBackendModel: ObservableObject {
    
    @Published var list2 : StripeCustomer = StripeCustomer(FirstName: "", HairStyle: "", LastName: "", customer_id: "", ephemeralKey: "", setup_secret: "")
    private var db = Firestore.firestore()
    
    
    //MARK: Hard coded, need to change to reference
    private var amount = "5.00"
    private var cusID = "RYApeerZQwQzIGv9ovCvsWAWUnr1"
    // let db = Firestore.firestore()
    
    @Published var paymentSheet: PaymentSheet?
    @Published var paymentResult: PaymentSheetResult?
    
    func preparePaymentSheet() {
        // MARK: Fetch the PaymentIntent and Customer information from the backend
        // var request = URLRequest(url: backendCheckoutUrl)
        // request.httpMethod = "POST"
        //  let task = URLSession.shared.dataTask(with: request, completionHandler: { [weak self] (data, response, error) in
        //    guard let data = data,
        //         let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any],
        //let customerId = json["customer"] as? String,
        // let customerEphemeralKeySecret = json["ephemeralKey"] as? String,
        //     let paymentIntentClientSecret = json["paymentIntent"] as? String,
        // let publishableKey = json["publishableKey"] as? String,
        
        
        self.fetchStripeFirebaseData()
        self.createPaymentIntent()
        
        
        //MARK: DO NOT Leave, need to change
        let paymentIntentClientSecret = "pi_3NgQiFLn6NfP8QkI0ys9ZlXG_secret_aNr1nvIxt8uF0o4RwtWicpbol"
        let customerId = self.list2.customer_id
        let customerEphemeralKeySecret = self.list2.ephemeralKey
        //let customerId = fetchStripeFirebaseData()
        let publishableKey = "pk_test_51MLoN5Ln6NfP8QkIyweffNkHamevd46IZdUFQundD5CCFD0f7IO0zUu9HjFaQ2GkycyABvxZYKzAGCdroXSr3swp00wey0QPoV"
        STPAPIClient.shared.publishableKey = publishableKey
        
        // MARK: Create a PaymentSheet instance
        var configuration = PaymentSheet.Configuration()
        configuration.merchantDisplayName = "Example, Inc."
        configuration.customer = .init(id: customerId, ephemeralKeySecret: customerEphemeralKeySecret)
        
        // Set `allowsDelayedPaymentMethods` to true if your business can handle payment
        // methods that complete payment after a delay, like SEPA Debit and Sofort.
        configuration.allowsDelayedPaymentMethods = false
        
        DispatchQueue.main.async {
            self.paymentSheet = PaymentSheet(paymentIntentClientSecret: paymentIntentClientSecret, configuration: configuration)
        }
        //})
       
    }
    
    func createPaymentIntent () {
        let functions = Functions.functions()
        
        db.collection("stripe_customers").document(self.cusID).collection("payment_methods").addDocument(data: ["payment_method":  "card"])
        
        db.collection("stripe_customers").document(self.cusID).collection("payments").addDocument(data: ["amount": 500, "currency": "usd", "automatic_payment_methods": ["enabled": "true"]])
        
          functions.useEmulator(withHost: "127.0.0.1", port: 5001)
        
        //IP Address    
        //  functions.useEmulator(withHost: "192.168.1.8", port: 5001)
        
        
        functions.httpsCallable("createStripePayment").call { result, error in
            if let error = error {
                //handle error
                print(error)
                
            } else {
                let response = result
                let paymentIntentClientSecret = result?.data
                
                print(result)
            }
        }
    }
   
    
    func fetchStripeFirebaseData() {
        
        
        db.collection("stripe_customers").document(Auth.auth().currentUser!.uid).getDocument { snapshot, error in
            //check for errors
            if error == nil {
                if let snapshot = snapshot  {
                    
                    //DispatchQueue.main.async {
                    //Get all collections
                    
                    self.list2 = snapshot.data().map { d in
                        
                        return StripeCustomer(
                            FirstName: d["FirstName"] as? String ?? "",
                            HairStyle: d["HairStyle"] as? String ?? "",
                            LastName: d["LastName"] as? String ?? "",
                            customer_id: d["customer_id"] as? String ?? "",
                            ephemeralKey: d["ephemeralKey"] as? String ?? "",
                            setup_secret: d["setup_secret"] as? String ?? "")
                    }!
                    
                    
                    // }
                    
                } else {
                    //To DO: Handle Error
                }
            }
                 
        }
    }
        
        func onPaymentCompletion(result: PaymentSheetResult) {
            self.paymentResult = result
        }
    
}

struct CheckoutView: View {
  @ObservedObject var model = MyBackendModel()
    

  var body: some View {
      
    VStack {
        
        if let paymentSheet = model.paymentSheet {
            
            PaymentSheet.PaymentButton(
                paymentSheet: paymentSheet,
                onCompletion: model.onPaymentCompletion
            ) {
                Text("Buy")
            }
        } else {
        Text("Loading…")
      }
        if let result = model.paymentResult {
                switch result {
                case .completed:
                  Text("Payment complete")
                case .failed(let error):
                  Text("Payment failed: \(error.localizedDescription)")
                case .canceled:
                  Text("Payment canceled.")
                }
              }
        
    }
    .onAppear { model.preparePaymentSheet() }
  }
}

