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
    @Binding var stripeAddress: AddressViewController.AddressDetails.Address?
   
    var body: some View {
        Text("Purchase complete")
            .onAppear{
                model.getSubTotal()
                model.uploadPurchaseSuccess(address: address(line1: stripeAddress?.line1 ?? "", line2: stripeAddress?.line2 ?? "", postal_code: stripeAddress?.postalCode ?? "", state: stripeAddress?.state ?? "", city: stripeAddress?.city ?? ""), amount: model.subtotal)
                model.purchased.removeAll()
            }
    }

        
    
}

    
