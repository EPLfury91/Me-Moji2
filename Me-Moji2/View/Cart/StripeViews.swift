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

struct ExamplePaymentButtonView: View {
    var body: some View {
        HStack {
            Text("Buy").fontWeight(.bold)
        }
        .frame(minWidth: 200)
        .padding()
        .foregroundColor(.white)
        .background(Color.blue)
        .cornerRadius(6)
        .accessibility(identifier: "Buy button")
    }
}

struct ExampleLoadingView: View {
    var body: some View {
        if #available(iOS 14.0, *) {
            ProgressView()
        } else {
            Text("Preparing payment…")
        }
    }
}

struct ExamplePaymentStatusView: View {
    let result: PaymentSheetResult

    var body: some View {
        HStack {
            switch result {
            case .completed:
                Image(systemName: "checkmark.circle.fill").foregroundColor(.green)
                Text("Your order is confirmed!")
            case .failed(let error):
                Image(systemName: "xmark.octagon.fill").foregroundColor(.red)
                Text("Payment failed: \(error.localizedDescription)")
            case .canceled:
                Image(systemName: "xmark.octagon.fill").foregroundColor(.orange)
                Text("Payment canceled.")
            }
        }
        .accessibility(identifier: "Payment status view")
    }
}

struct ExamplePaymentOptionView: View {
    let paymentOptionDisplayData: PaymentSheet.FlowController.PaymentOptionDisplayData?

    var body: some View {
        HStack {
            Image(uiImage: paymentOptionDisplayData?.image ?? UIImage(systemName: "creditcard")!)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 30, maxHeight: 30, alignment: .leading)
                .foregroundColor(.black)
            Text(paymentOptionDisplayData?.label ?? "Select a payment method")
                // Surprisingly, setting the accessibility identifier on the HStack causes the identifier to be
                // "Payment method-Payment method". We'll set it on a single View instead.
                .accessibility(identifier: "Payment method")
        }
        .frame(minWidth: 200)
        .padding()
        .foregroundColor(.black)
        .background(Color.init(white: 0.9))
        .cornerRadius(6)
    }
}

struct ExampleSwiftUIViews_Preview: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 12) {
            ExamplePaymentOptionView(paymentOptionDisplayData: nil)
            ExamplePaymentButtonView()
            ExamplePaymentStatusView(result: .canceled)
            ExampleLoadingView()
        }
    }
}


//MARK: THIS IS ONE we are using

import StripePaymentSheet
import SwiftUI

class MyBackendModel: ObservableObject {
    
    @Published var list2 : StripeCustomer = StripeCustomer(FirstName: "", HairStyle: "", LastName: "", customer_id: "", setup_secret: "")
    private var db = Firestore.firestore()
    
    //Comment out at some point
    //  let backendCheckoutUrl = URL(string: "Your backend endpoint")! // Your backend endpoint
    //StripeAPI.defaultPublishableKey = "pk_test_51MLoN5Ln6NfP8QkIyweffNkHamevd46IZdUFQundD5CCFD0f7IO0zUu9HjFaQ2GkycyABvxZYKzAGCdroXSr3swp00wey0QPoV"
    
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
    
    
    //     let self = self else {
    // Handle error
    //     return
//}
        
        self.fetchStripeFirebaseData()
        
     // let paymentIntentClientSecret = json["paymentIntent"] as? String,
         let paymentIntentClientSecret = "bfdsbf"
        let  customerId = list2.customer_id
        let customerEphemeralKeySecret = list2.setup_secret
        //let customerId = fetchStripeFirebaseData()
        let publishableKey = "pk_test_51MLoN5Ln6NfP8QkIyweffNkHamevd46IZdUFQundD5CCFD0f7IO0zUu9HjFaQ2GkycyABvxZYKzAGCdroXSr3swp00wey0QPoV"

      STPAPIClient.shared.publishableKey = publishableKey
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
    //})
   // task.resume()
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
    }.onAppear { model.preparePaymentSheet() }
  }
}
