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
    
    var body: some View {
        VStack{
            HStack{
                Text("Shipping Address")
                
                
                Toggle("Same as Billing Adress", isOn: $SameAddress)
                    .toggleStyle(.switch)
            }
            
            
            textOutlineView(inputValue: $Street1, displayValue: "Street 1")
            textOutlineView(inputValue: $Street2, displayValue: "Street 2")
            textOutlineView(inputValue: $Town, displayValue: "Town")
            textOutlineView(inputValue: $State, displayValue: "State")
            textOutlineView(inputValue: $Zip, displayValue: "Zip")
        }
    }
}

