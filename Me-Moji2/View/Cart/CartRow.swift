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
                    
                    
                    NavigationLink(destination: {
                        //To do - Navigate to edit section
                        CardWordCustomization(item: item.item)
                    }, label: {
                        Text("Edit")
                           
                    })
                    
                    Button(action: {
                        if let item = model.purchased.firstIndex(where: {$0.id == item.id}) {
                            model.purchased.remove(at: item)
                        }
                    }, label: {
                        Text("Remove")
                            
                    })
                }
                 
            }
            
        }
        
    }
}

