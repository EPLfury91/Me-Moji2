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

//View that is displayed
struct CheckoutView: View {
    @Binding var checkoutScreen: CheckoutScreen
    @EnvironmentObject var model: MyBackendModel
    @EnvironmentObject var model2: ContentModel
    
    var body: some View {
        VStack{
            if model.paymentSheet == nil {
                Text("Loading")
            } else {
                switch model.paymentResult {
                case .completed:
                    Button(action: { 
                        checkoutScreen = .Completion(address: model.address.address, name: model.address.name ?? "")}
                           ,label: {
                        Text("Success! Review Purchase")
                    })
                    
                case .failed(let error):
                    Text("Payment failed: \(error.localizedDescription)")
                case .canceled:
                    Text("Payment canceled.")
                case .none:
                    
                    //Order Review and Purchase Screen
                    VStack(alignment: .leading){
                        Text("Shipping Address Review")
                            .padding(.leading,20)
                            .font(.subheadline)
                        
                        FullAddressDisplayViewStripe(address: model.address.address, name:  model.address.name ?? "")
                        
                        Spacer()
                        
                        Text("Item Review")
                            .padding(.leading,20)
                            .font(.subheadline)
                        
                        ScrollView{
                            ForEach(model2.purchased, id: \.id){ index in
                                CartRow(item: index)
                            }
                        }
                        Divider()
                        
                        HStack{
                            Spacer()
                            Text("Total: $ \(String(model2.subtotal))")
                        }
                        
                        HStack{
                            Spacer()
                            PaymentSheet.PaymentButton(paymentSheet: model.paymentSheet!) { result in
                                model.onPaymentCompletion(result: result)
                            } content: {
                                buttonDisplay(buttonLabel: "Complete Purchase", isDisabled: false)
                            }
                            Spacer()
                        }
                        
                    }
                    
                    .navigationTitle(Text("Order Review"))
                }
            }
        }
        .task {
            do {
                try await model.createPaymentIntent()
                model.preparePaymentSheet()
            } catch {
                print("Error")
            }
            
        }
    }
}

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
    
    func preparePaymentSheet() {
        // MARK: Fetch the PaymentIntent and Customer information from the backend
        //MARK: DO NOT Leave, need to change
            let customerId = self.list2.customer_id
            let customerEphemeralKeySecret = self.list2.ephemeralKey
            let publishableKey = "pk_test_51MLoN5Ln6NfP8QkIyweffNkHamevd46IZdUFQundD5CCFD0f7IO0zUu9HjFaQ2GkycyABvxZYKzAGCdroXSr3swp00wey0QPoV"
            STPAPIClient.shared.publishableKey = publishableKey
            
            // MARK: Create a PaymentSheet instance
            var configuration = PaymentSheet.Configuration()
        
            configuration.merchantDisplayName = "Ava-Card, Inc."
            configuration.customer = .init(id: customerId, ephemeralKeySecret: customerEphemeralKeySecret)
//            configuration.shippingDetails = {
//                self.address.addressDetail
//            }
            configuration.billingDetailsCollectionConfiguration.attachDefaultsToPaymentMethod = true

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
        
        try await fetchStripeFirebaseData()
        
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
      
        Functions.functions().httpsCallable("createCustomerEphmeral2").call(["cusId": self.list2.customer_id, "FirebaseID": Auth.auth().currentUser?.uid]) { results, error in
                            print(error?.localizedDescription)
            
            }
        sleep(1)
        
        try await fetchStripeFirebaseData()
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

