//
//  FullCheckoutView.swift
//  Me-Moji2
//
//  Created by Brett Tracey on 9/29/23.
//

import SwiftUI
import StripePaymentSheet


enum CheckoutScreen {
    case Checkout(address: AddressViewController.AddressDetails.Address?)
    case Address
    case Completion(address: AddressViewController.AddressDetails.Address?, name: String)
    case CartView
}

struct FullerCheckoutView: View {
    @EnvironmentObject var model : MyBackendModel
    @State var checkoutScreen: CheckoutScreen = .Address
    @State var isPresented = false
    
    var body: some View {
        VStack{
            switch checkoutScreen {
                case .Address: FullCheckoutView(checkoutScreen: $checkoutScreen)
                case .Checkout(address: let address): CheckoutView(checkoutScreen: $checkoutScreen)
                case .Completion(address: let address1, name: let name): Purchase_Success(stripeAddress: address1, name: name)
                case .CartView: CartView(isPresented: $isPresented, checkoutScreen: $checkoutScreen)
            }
        }
    }
}

struct FullCheckoutView: View {
    @Binding var checkoutScreen: CheckoutScreen
    @EnvironmentObject var model : MyBackendModel
    @State var name: String?
    @State var name2: String?
    @State var phone: String?
    @State var isTapped = false
    
    var body: some View {
        VStack{
            ZStack{
                RoundedRectangle(cornerRadius: 18)
                    .frame(width: UIScreen.main.bounds.width / 1.05 , height: 90, alignment: .leading)
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
                    AddressView(isTapped: $isTapped, phone: model.address.phone, address: address(name: model.address.name!, line1: model.address.address!.line1, line2: model.address.address!.line2 ?? "", postal_code: model.address.address!.postalCode!, state: model.address.address!.state!, city: model.address.address!.city!))
                        
                }
            }
            
            Button{
                checkoutScreen = .Checkout(address: model.address.address)
            } label: {
                buttonDisplay(buttonLabel: "Order Review", isDisabled: model.address.address?.line1 == nil)
            }

        }
        .sheet(isPresented: $isTapped, content: {
            NavigationView{
                    //MARK: Add x button to close sheet
                    AddressViewSwift(name: $model.address.name, address: $model.address.address, phone: $phone, model: _model)
            }
        })
        .navigationTitle("Shipping Address")
  }
}

