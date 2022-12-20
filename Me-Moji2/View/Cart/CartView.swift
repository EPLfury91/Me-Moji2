//
//  CartView.swift
//  Me-Moji2
//
//  Created by Brett Tracey on 12/13/22.
//

import SwiftUI

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
                
                let subtotal = model.getSubTotal()
                Text("$ \(String(subtotal))")
                
            }
            
            
            
        }
    }
      
        
}
    

