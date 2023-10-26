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

struct Address {
     var address: AddressViewController.AddressDetails.Address?
     var addressDetail: AddressViewController.AddressDetails?
     var name: String?
     var phone: String?
}

//MARK: THIS IS ONE we are using
class MyBackendModel: ObservableObject {
    @Published var list2 : StripeCustomer = StripeCustomer(FirstName: "", HairStyle: "", LastName: "", customer_id: "", ephemeralKey: "", setup_secret: "")
    @Published var address: Address = Address()
    
    //MARK: Update code to remove this reference, use collection
    private var db = Firestore.firestore()
    var paymentIntentClientSecret : String = ""
    //MARK: Hard coded, need to change to reference
    //CustomerID in firebase
    private var cusID = String(describing: Auth.auth().currentUser!.uid)
    private var secret = ""
    let productsCollection =  Firestore.firestore().collection("stripe_customers").document(Auth.auth().currentUser!.uid).collection("payments")
    @Published var paymentSheet: PaymentSheet?
    @Published var paymentResult: PaymentSheetResult?
    @Published var flowController: PaymentSheet.FlowController?
    var myData = [
        "cusID2": "cus_OsyUiWo4F6wr2h",
        "FirebaseId": Auth.auth().currentUser!.uid
    ]
    

    func preparePaymentSheet() {
        // MARK: Fetch the PaymentIntent and Customer information from the backend
        //MARK: DO NOT Leave, need to change
            let customerId = self.list2.customer_id
            let customerEphemeralKeySecret = self.list2.ephemeralKey
            let publishableKey = "pk_test_51MLoN5Ln6NfP8QkIyweffNkHamevd46IZdUFQundD5CCFD0f7IO0zUu9HjFaQ2GkycyABvxZYKzAGCdroXSr3swp00wey0QPoV"
            STPAPIClient.shared.publishableKey = publishableKey
            
            // MARK: Create a PaymentSheet instance
            var configuration = PaymentSheet.Configuration()
        
            configuration.merchantDisplayName = "Example, Inc."
            configuration.customer = .init(id: customerId, ephemeralKeySecret: customerEphemeralKeySecret)
            configuration.shippingDetails = {
                self.address.addressDetail
            }

            // Set `allowsDelayedPaymentMethods` to true if your business can handle payment
            // methods that complete payment after a delay, like SEPA Debit and Sofort.
            configuration.allowsDelayedPaymentMethods = false
        
        //MARK: Dont want to do on main thread!!
            paymentIntentClientSecret = self.secret
        
        
        self.paymentSheet = PaymentSheet(paymentIntentClientSecret: paymentIntentClientSecret, configuration: configuration)
        
    }
    
    func orderIntents() async throws -> QuerySnapshot {
        let docId  = try await productsCollection.order(by: "created", descending: true).getDocuments()
    
        return docId
    }
    
    func createPaymentIntent () async throws {

        let docId = try await orderIntents()
        
        try db.collection("stripe_customers").document(Auth.auth().currentUser!.uid).collection("payments").document(docId.documents[0].documentID).addSnapshotListener { snapshot, error in
            guard let docSnapshot = snapshot else {
                            print(error?.localizedDescription)
                            return
            }
            guard  docSnapshot.get("client_secret") == nil else {
                let different = docSnapshot.get("client_secret")
                    print(different)
                    self.secret = String(describing: different!)
                    return
                }
            
        }
            
            
        Functions.functions().httpsCallable("createCustomerEphmeral2").call(["cusId": "cus_OtG5S2GycAW5XV", "FirebaseID": Auth.auth().currentUser?.uid]) { results, error in
                            print(error?.localizedDescription)
            
            }
                        
        
        
//        db.collection("stripe_customers").document(Auth.auth().currentUser!.uid).collection("payments").addSnapshotListener { snapshot, error in
//            guard let docSnapshot = snapshot else {
//                print(error?.localizedDescription)
//                return
//            }
//            
//            docSnapshot.documentChanges.forEach { diff in
//                if (diff.type == .added) {
//                  
//                    guard diff.document.get("client_secret") == nil else {
//                        let different = diff.document.get("client_secret")
//                        print(different)
//                        
//                        self.secret = String(describing: different!)
//                        return
//                    }
//                   //pi_3O5TzZLn6NfP8QkI0RYX51yy_secret_9KzmNVq5UsGJPAETFeavuW5GY
//                   //pi_3O5TbSLn6NfP8QkI0d8zIFfc_secret_3kyP55AUOjxy8cQywIt51tEcg
//                    //pi_3O5UFyLn6NfP8QkI13pzwUbA_secret_TT0WBfH4l0m4ySF7eoGWByVVh
//                     
//                } else if(diff.type == .modified) {
//                    guard diff.document.get("client_secret") == nil else {
//                        let different = diff.document.get("client_secret")!
//                        self.secret =  String(describing: different)
//                        return
//                    }
//            
//                }
//                
//            }
//            
//           
//            Functions.functions().httpsCallable("createCustomerEphmeral2").call(["cusId": "cus_OtG5S2GycAW5XV", "FirebaseID": "HHHHH"]) { results, error in
//                print(error?.localizedDescription)
//               
//            }
//                
//        }
//            
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
                    
                    //ek_test_YWNjdF8xTUxvTjVMbjZOZlA4UWtJLEFzYkhjOEtuN0lXMmpwbjBrdTBjWUNJZGpOUTNxUUw_00d7uhUZ09
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
    @EnvironmentObject var model: MyBackendModel
    @Binding var address: AddressViewController.AddressDetails.Address?
    
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
                    
                        Purchase_Success(stripeAddress: $address)
                
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

