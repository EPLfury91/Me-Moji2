//
//  CartView.swift
//  Me-Moji2
//
//  Created by Brett Tracey on 12/13/22.
//

import SwiftUI
import Stripe
import StripePaymentSheet
import UIKit
import Foundation
import FirebaseAuth
import FirebaseFirestore


//Sheet pops up that displays items in cart
struct CartView: View {
    
    //Variables
    @EnvironmentObject var model: ContentModel
    @State var count = 0
    @State var subtotal = 0
    let db = Firestore.firestore()
    let cusId = Auth.auth().currentUser?.uid
    @Binding var isPresented : Bool
    @Binding var checkoutScreen: CheckoutScreen
    
    var body: some View {
        
        VStack{
            
            //Overrides purchase success view
            if model.purchased.count == 0 {
                Text("No items in cart")
            }else {
                GeometryReader{ geo in
                    
                    VStack(alignment: .leading){
                        HStack{
                            Text("Item")
                            Spacer()
                            Text("Subtotal")
                            
                        }
                        
                        Divider()
                        
                        //Insert rows here (picture as well as edit/remove button)
                        ScrollView{
                            ForEach(model.purchased){ index in
                                CartRow(item: index)
                                Divider()
                            }
                            
                        }
                        
                        Divider()
                        
                        HStack{
                            Text("Subtotal")
                            
                            Spacer()
                            
                            Text("$ \(model.subtotal)")
                            
                        }
                        
                        HStack{
                            Spacer()
                            
                            Button {
                                checkoutScreen = .Address
                            } label: {
                                buttonDisplay(buttonLabel: "Proceed to Checkout")
                            }.simultaneousGesture(TapGesture().onEnded{
                                
                                db.collection("stripe_customers").document(self.cusId ?? "").collection("payments").addDocument(data: ["amount": model.subtotal*100, "currency": "usd", "automatic_payment_methods": ["enabled": "true"]])
                                
                            })

                            
                            
    //                        NavigationLink(destination: {
    //                            FullerCheckoutView()
    //                        }, label: {
    //                            buttonDisplay(buttonLabel: "Proceed to Checkout")
    //                        })
                            
                            Spacer()
                        }
                    }
                    
                }
                .border(.green)
            }
        }
        .toolbar(content: {
            Button {
                isPresented.toggle()
            } label: {
                XbuttonView()
            }

        })
        .onAppear{
                 model.getSubTotal()
        }
    }
    
         
}
    


    




