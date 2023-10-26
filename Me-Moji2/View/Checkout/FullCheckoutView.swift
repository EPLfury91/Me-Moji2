//
//  FullCheckoutView.swift
//  Me-Moji2
//
//  Created by Brett Tracey on 9/29/23.
//

import SwiftUI
import StripePaymentSheet

struct FullCheckoutView: View {
    
    @EnvironmentObject var model : MyBackendModel
    @State var name: String?
    @State var name2: String?
    @State var phone: String?
    @State var isTapped = false
    
    var body: some View {
        VStack{
            ZStack{
                RoundedRectangle(cornerRadius: 18)
                    .frame(width: UIScreen.main.bounds.width / 1.05 , height: 120, alignment: .leading)
                    .foregroundColor(.black)
                
                if model.address.name == nil {
                    Button {
                        self.isTapped = true
                    } label: {
                        HStack{
                            Text("Add Address")
                            Image(systemName: "plus")
                        }
                    }
                } else {
                    AddressView(isTapped: $isTapped, name2: model.address.name, phone: model.address.phone, address: model.address.address)
                }
                
            }
            
            NavigationLink {
                CheckoutView(address: $model.address.address)
            } label: {
                Text("Payment Information")
            }

        }
        .sheet(isPresented: $isTapped, content: {
          
                NavigationView{
                    //MARK: Add x button to close sheet
                    AddressViewSwift(name: $model.address.name, address: $model.address.address, phone: $phone, model: _model)
            }
        })
  }
}

