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
    var name: String
    
    var body: some View {
        VStack(alignment: .leading){
            Text("You will receive an email shortly with your order details! Thank you!")
            Text("Your order confirmation number is: \(model.firebaseItem.id!)")
            Text("Purchase Date: \(model.firebaseItem.date, style: .date)")
            Text("Shipping Address:")
            FullAddressDisplayView(address: model.firebaseItem.address)
       
            
            Text("Items Purchased:")
            List(model.firebaseItem.Products){ index in
              PurchaseHistoryRow(item: index)
            }
            
            Divider()
            
            HStack{
                Spacer()
                Text("Order Total $\(model.subtotal)")
            }
           
            
            HStack{
                Spacer()
                Button {
                    model.CartTapped.toggle()
                } label: {
                    buttonDisplay(buttonLabel: "Dismiss", isDisabled: false)
                }
                Spacer()
            }

        }
        .navigationTitle("Order Summary")
        .onAppear{
            model.getSubTotal()
            Task{
                do {
                    let ref = try await model.uploadPurchaseSuccess(address: address(name: name,line1: stripeAddress?.line1 ?? "", line2: stripeAddress?.line2 ?? "", postal_code: stripeAddress?.postalCode ?? "", state: stripeAddress?.state ?? "", city: stripeAddress?.city ?? ""), amount: model.subtotal)
                    try await model.downloadOnePurchase(reference: ref)
                } catch {
                    print(error.localizedDescription)
                }
                
            }
            
          
        }
    }
}
