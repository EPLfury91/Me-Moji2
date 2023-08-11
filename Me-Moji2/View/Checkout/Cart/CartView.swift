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


struct CartView: View {
    @EnvironmentObject var model: ContentModel
    @State var count = 0
    
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
            
            //Insert rows here
            ForEach(model.purchased){ index in
                CartRow(item: index)
                
            }
            
            
            Divider()
               
            HStack{
                Text("Subtotal")
                
                Spacer()
                
                let subtotal = model.getSubTotal()
                Text("$ \(String(subtotal))")
                
            }
            .padding(.horizontal, 5)
            
            
            HStack{
                Spacer()
                
                NavigationLink(destination: {
                   CheckoutView()
                }, label: {
                    buttonDisplay(buttonLabel: "Proceed to Checkout")
                })
                
                Spacer()
            }
            .padding(.horizontal, 5)
            
            
        }
    }
         
}


    




