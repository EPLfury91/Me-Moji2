//
//  FullCheckoutView.swift
//  Me-Moji2
//
//  Created by Brett Tracey on 9/29/23.
//

import SwiftUI
import StripePaymentSheet

struct FullCheckoutView: View {
  //  @EnvironmentObject var helper: Helper
    @State var name: String?
    @State var name2: String?
    @State var address: AddressViewController.AddressDetails.Address?
    @State var isTapped = false
    
    var body: some View {
        VStack{
            
            VStack(alignment: .leading, spacing: 0){
                HStack{
                    Spacer()
                    
                    Button(action:  {
                        self.isTapped = true
                    }, label: {
                        Text("Edit Address")
                    })
                }
                    
                AddressDisplayView(text: name2 ?? "n/A")
                AddressDisplayView(text: address?.line1 ?? "n/A")
                AddressDisplayView(text: address?.line2 ?? "n/A")
                
            }
            

            Spacer()
            
            NavigationLink {
                CheckoutView()
            } label: {
                Text("Payment Information")
            }

        }
        .sheet(isPresented: $isTapped, content: {
            NavigationView{
                AddressViewSwift(name: $name2, address: $address)
                 //   .environmentObject(Helper())
            }
          //  .onChange(of: name2) {_ in loadAddress()}
          //  .onChange(of: address) {_ in loadAddress()}
           // .environmentObject(Helper())
           
        })
        
        
    }
  //  func loadAddress() {
     
  //  }
}

