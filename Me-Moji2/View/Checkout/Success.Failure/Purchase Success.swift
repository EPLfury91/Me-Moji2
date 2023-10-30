//
//  Purchase Success.swift
//  Me-Moji2
//
//  Created by Brett Tracey on 9/19/23.
//

import SwiftUI
import StripePaymentSheet

struct Purchase_Success: View {
    @EnvironmentObject var model: ContentModel
    var stripeAddress: AddressViewController.AddressDetails.Address?
   
    var body: some View {
        VStack{
           Text("Order Review")
            ForEach(model.purchased){index in
                CartRow(item: index)
            }
            Text("Order Total \(model.subtotal)")
            
        }
            .onAppear{
                model.getSubTotal()
                model.uploadPurchaseSuccess(address: address(line1: stripeAddress?.line1 ?? "", line2: stripeAddress?.line2 ?? "", postal_code: stripeAddress?.postalCode ?? "", state: stripeAddress?.state ?? "", city: stripeAddress?.city ?? ""), amount: model.subtotal)
              
            }
    }

        
    
}

    
