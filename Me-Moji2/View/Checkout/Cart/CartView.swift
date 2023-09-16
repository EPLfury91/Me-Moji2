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


struct CartView: View {
    
    //Variables
    @EnvironmentObject var model: ContentModel
    @State var count = 0
    @State var subtotal = 0
    let db = Firestore.firestore()
    let cusId = Auth.auth().currentUser?.uid
    
    var body: some View {
        VStack(alignment: .leading){
            HStack{
                Text("Item")
                
                Spacer()
                
                Text("Description")
                
                Spacer()
                
                Text("Price")
            }
            .padding(.horizontal, 20)
            
            Divider()
            
            //Insert rows here (picture as well as edit/remove button)
            ForEach(model.purchased){ index in
                CartRow(item: index)
            }

            Divider()
               
            HStack{
                Text("Subtotal")
                
                Spacer()
                 
                Text("$ \(model.subtotal)")
                
            }
            .padding(.horizontal, 5)
            
            
            HStack{
                Spacer()
                
                NavigationLink(destination: {
                    CheckoutView()
                }, label: {
                    buttonDisplay(buttonLabel: "Proceed to Checkout")
                }).simultaneousGesture(TapGesture().onEnded{
                    
                    db.collection("stripe_customers").document(self.cusId ?? "").collection("payments").addDocument(data: ["amount": model.subtotal*100, "currency": "usd", "automatic_payment_methods": ["enabled": "true"]])
            
                })
                
                Spacer()
            }
            .padding(.horizontal, 5)
             
        }
        .onAppear{
                 model.getSubTotal()
        }
    }
    
         
}
    


    




