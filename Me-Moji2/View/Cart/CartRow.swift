//
//  CartRow.swift
//  Me-Moji2
//
//  Created by Brett Tracey on 12/14/22.
//

import SwiftUI

struct CartRow: View {
    @EnvironmentObject var model: ContentModel
  //  var count: Int
    var item: Purchased
    
    var body: some View {
        
        
        HStack(spacing: 10){
            Image(item.item.image)
                .resizable()
                .frame(width: 75, height: 75)
            
            Spacer()
            
                  Text(item.item.name)
            
            Spacer()
            
            //Price/Remove/Edit Buttons
            VStack{
                Text("$\(String(item.item.price))")
                
                HStack{
                    Button(action: {
                        model.purchased.firstIndex(where: try UUID == item.item.id)
                        model.deleteItem(index: item.item.id)
                    }, label: {
                        Text("Remove")
                    })
                }
                 
            }
            
        }
        
    }
}

