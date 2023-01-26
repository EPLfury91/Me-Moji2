//
//  AddressView.swift
//  Me-Moji2
//
//  Created by Brett Tracey on 12/31/22.
//

import SwiftUI

struct AddressView: View {
    
    @State var Street1 = ""
    @State var Street2 = ""
    @State var Town = ""
    @State var State = ""
    @State var Zip = ""
    @State var SameAddress = false
    
    @State var BillingStreet1 = ""
    
    var body: some View {
        
        ScrollView{
            VStack(alignment: .leading, spacing: 1){
            Text("https://buy.stripe.com/test_28o7tqfTQ0o4fqE6oo")
                
                
                
         /*       Text("Shipping Address")
                
                textOutlineView(inputValue: $Street1, displayValue: "Street 1")
                textOutlineView(inputValue: $Street2, displayValue: "Street 2")
                textOutlineView(inputValue: $Town, displayValue: "Town")
                textOutlineView(inputValue: $State, displayValue: "State")
                textOutlineView(inputValue: $Zip, displayValue: "Zip")
                    
                
                HStack{
                    Text("Billing Address")
                    
                    Spacer()
                    
                    Toggle("Same as Shipping Adress", isOn: $SameAddress)
                        .toggleStyle(.switch)
                }
                
                textOutlineView(inputValue: $BillingStreet1, displayValue: "Street 1")
                    .disabled(SameAddress)*/
                
            }
        }
       
    }
}

