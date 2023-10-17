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
    @State var phone: String?
    @State var address: AddressViewController.AddressDetails.Address?
    @State var isTapped = false
    
    var body: some View {
        VStack{
            ZStack{
                RoundedRectangle(cornerRadius: 18)
                    .frame(width: UIScreen.main.bounds.width / 1.05 , height: 120, alignment: .leading)
                    .foregroundColor(.black)
                
                if name2 == nil{
                    Button {
                        self.isTapped = true
                    } label: {
                        HStack{
                            Text("Add Address")
                            Image(systemName: "plus")
                        }
                       
                    }

                } else {
                    AddressView(isTapped: $isTapped, name2: $name2, phone: $phone, address: $address)
                }
                
            }
            
            NavigationLink {
                CheckoutView()
            } label: {
                Text("Payment Information")
            }

        }
        .sheet(isPresented: $isTapped, content: {
          
                NavigationView{
//                    Button {
//                        self.isTapped = false
//                    } label: {
//                        XbuttonView()
//                    }
                    AddressViewSwift(name: $name2, address: $address, phone: $phone)
                   
                
            }
          
          //  .onChange(of: name2) {_ in loadAddress()}
          //  .onChange(of: address) {_ in loadAddress()}
          
           
        })
        
        
    }
  //  func loadAddress() {
     
  //  }
}

