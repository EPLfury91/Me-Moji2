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


struct CheckoutView: View {
    @ObservedObject var model: firebaseFunctions = firebaseFunctions()
    var body: some View {
        VStack{
            Button {
            //    model.createStripeCustomer()
            } label: {
                Text("Create Stripe Customer")
            }

        }
    }
}




class MyBackendModel: ObservableObject {
 let backendCheckoutUrl = URL(string: "https://console.firebase.google.com/u/0/project/me-moji2/overview" + "createStripeCustomer")! // Your backend endpoint
   
  @Published var paymentSheet: PaymentSheet?
  @Published var paymentResult: PaymentSheetResult?
  @Published var stripePublishableKey : String = ""
    

    
    
 
    func getPublishKey () {
        Functions.functions().httpsCallable("getStripePublishablekey").call { (response, error) in
                    if let error = error {
                        print(error)
                    }
            
                    if let response = (response?.data as? [String: Any]) {
                        self.stripePublishableKey = (response["publishableKey"] as! String?)!
                      //  StripeAPI.defaultPublishableKey(stripePublishableKey!)
                        Stripe.setDefaultPublishableKey(self.stripePublishableKey)
                       // print(stripePublishableKey)
                        
                    }
                }
    }
    
    
        
        
    

  func preparePaymentSheet() {
    // MARK: Fetch the PaymentIntent and Customer information from the backend
      
      //comment out
    var request = URLRequest(url: backendCheckoutUrl)
    request.httpMethod = "POST"
    let task = URLSession.shared.dataTask(with: request, completionHandler: { [weak self] (data, response, error) in
      guard let data = data,
            let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any],
            let customerId = json["customer"] as? String,

            //let customerEphemeralKeySecret = getSecretKey()
            let customerEphemeralKeySecret = json["ephemeralKey"] as? String,
            let paymentIntentClientSecret = json["paymentIntent"] as? String,
            let publishableKey = json["publishableKey"] as? String,
            let self = self else {
      //   Handle error
        return
      }
        
        //trying functions
        getPublishKey()
        
        //comment out
     //   STPAPIClient.shared.publishableKey = getPublishKey()
      // MARK: Create a PaymentSheet instance
      var configuration = PaymentSheet.Configuration()
      configuration.merchantDisplayName = "Example, Inc."
      configuration.customer = .init(id: customerId, ephemeralKeySecret: customerEphemeralKeySecret)
      // Set `allowsDelayedPaymentMethods` to true if your business can handle payment
      // methods that complete payment after a delay, like SEPA Debit and Sofort.
      configuration.allowsDelayedPaymentMethods = true

      DispatchQueue.main.async {
        self.paymentSheet = PaymentSheet(paymentIntentClientSecret: paymentIntentClientSecret, configuration: configuration)
      }
    })
    task.resume()
  }
    
    func onPaymentCompletion(result: PaymentSheetResult) {
        self.paymentResult = result
      }
    
}


//struct CheckoutView: View {
//  @ObservedObject var model = MyBackendModel()
//
//  var body: some View {
//    VStack {
//      if let paymentSheet = model.paymentSheet {
//        PaymentSheet.PaymentButton(
//          paymentSheet: paymentSheet,
//          onCompletion: model.onPaymentCompletion
//        ) {
//          Text("Buy")
//        }
//      } else {
//        Text("Loading…")
//      }
//      if let result = model.paymentResult {
//        switch result {
//        case .completed:
//          Text("Payment complete")
//        case .failed(let error):
//          Text("Payment failed: \(error.localizedDescription)")
//        case .canceled:
//          Text("Payment canceled.")
//        }
//      }
//    }.onAppear { model.preparePaymentSheet() }
//  }
//}

//struct ExampleSwiftUIPaymentSheet_Preview: PreviewProvider {
//    static var previews: some View {
//        ExampleSwiftUIPaymentSheet()
//    }
//}
