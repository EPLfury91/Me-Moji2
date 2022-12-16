//
//  CartView.swift
//  Me-Moji2
//
//  Created by Brett Tracey on 12/13/22.
//

import SwiftUI

struct CartView: View {
    @EnvironmentObject var model: ContentModel

    
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
            
            ForEach(model.purchased){ index in
                HStack{
                    Image(index.image)
                        .resizable()
                        .frame(width: 75, height: 75)
                    Spacer()
                    
                    Text(index.name)
                    
                    Spacer()
                    
                    Text(String(index.price))
                }
                .padding(.horizontal, 5)
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
    

