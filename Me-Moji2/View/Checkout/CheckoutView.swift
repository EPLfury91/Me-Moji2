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
    
    
    //MARK: Update code to remove this reference, use collection
    private var db = Firestore.firestore()
    var paymentIntentClientSecret : String?
        
    
    
    //MARK: Hard coded, need to change to reference
    //CustomerID in firebase
    private var cusID = String(describing: Auth.auth().currentUser!.uid)
    private var secret = ""
    let productsCollection =  Firestore.firestore().collection("stripe_customers").document(Auth.auth().currentUser!.uid).collection("payments")
    
    @Published var paymentSheet: PaymentSheet?
    @Published var paymentResult: PaymentSheetResult?
    
    func preparePaymentSheet() {
        // MARK: Fetch the PaymentIntent and Customer information from the backend
        //       self.fetchStripeFirebaseData()
            
        //MARK: DO NOT Leave, need to change
     
            let customerId = self.list2.customer_id
            let customerEphemeralKeySecret = self.list2.ephemeralKey
            let publishableKey = "pk_test_51MLoN5Ln6NfP8QkIyweffNkHamevd46IZdUFQundD5CCFD0f7IO0zUu9HjFaQ2GkycyABvxZYKzAGCdroXSr3swp00wey0QPoV"
            STPAPIClient.shared.publishableKey = publishableKey
            
            // MARK: Create a PaymentSheet instance
            var configuration = PaymentSheet.Configuration()
            configuration.merchantDisplayName = "Example, Inc."
            configuration.customer = .init(id: customerId, ephemeralKeySecret: customerEphemeralKeySecret)
            
            // Set `allowsDelayedPaymentMethods` to true if your business can handle payment
            // methods that complete payment after a delay, like SEPA Debit and Sofort.
            configuration.allowsDelayedPaymentMethods = false
        
        //MARK: Dont want to do on main thread!!
        
        
            paymentIntentClientSecret = self.secret
           
        
        
            self.paymentSheet = PaymentSheet(paymentIntentClientSecret: paymentIntentClientSecret!, configuration: configuration)
        
           
                 
       
    }
    
    
    func orderIntents() async throws -> QuerySnapshot {
        let docId  = try await productsCollection.order(by: "created").getDocuments()
    
        return docId
    }
    
    
    func createPaymentIntent () async throws {

        let docId = try await orderIntents()
        
        db.collection("stripe_customers").document(Auth.auth().currentUser!.uid).collection("payments").addSnapshotListener { snapshot, error in
            guard let docSnapshot = snapshot else {
                print(error?.localizedDescription)
                return
            }
            
            docSnapshot.documentChanges.forEach { diff in
                if (diff.type == .added) {
                  //  print("added \(diff.document.data())")
                    let different = diff.document.get("client_secret")
                    print(different)
                    
                    self.secret = String(describing: different)
                     
                } else if(diff.type == .modified) {
                    print("modified \(diff.document.data())")
                    let different = diff.document.get("client_secret")!
                    print(different)
                    self.secret =  String(describing: different)
            //        self.secret = String(describing: different)
                }
                
            }
        }
        
        sleep(1)
        
    
        
       
    }
   
    
    func fetchStripeFirebaseData() async throws {

        db.collection("stripe_customers").document(Auth.auth().currentUser!.uid).getDocument { snapshot, error in
            //check for errors
            if error == nil {
                if let snapshot = snapshot  {
                    
                    //DispatchQueue.main.async {
                    //Get all collections
                    
                    self.list2 =  StripeCustomer(
                            FirstName: String(describing: snapshot.get("FirstName")!),
                            HairStyle: String(describing: snapshot.get("HairStyle")!),
                            LastName: String(describing: snapshot.get("LastName")!),
                            customer_id: String(describing: snapshot.get("customer_id")!),
                            ephemeralKey: String(describing: snapshot.get("ephemeralKey")!),
                            setup_secret: String(describing: snapshot.get("setup_secret")!)
                    )}
                    
                    
                    // }
                    
                } else {
                    //To DO: Handle Error
                }
            }
                 
        sleep(1)
        
    }
        
        func onPaymentCompletion(result: PaymentSheetResult) {
            self.paymentResult = result
        }
    
}

//View that is displayed
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
                    NavigationView(content: {
                        Purchase_Success()
                    })
                case .failed(let error):
                  Text("Payment failed: \(error.localizedDescription)")
                case .canceled:
                  Text("Payment canceled.")
                }
              }
        
    }
    .task {
        do {
            try await model.createPaymentIntent()
            try await model.fetchStripeFirebaseData()
            model.preparePaymentSheet()
        } catch {
            print("Error")
        }
        
    }
  }
}

