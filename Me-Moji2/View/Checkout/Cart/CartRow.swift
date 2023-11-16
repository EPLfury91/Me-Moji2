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
        HStack(alignment: .center, spacing: 10){
            VStack{
                ZStack{
                    Image(item.item.card.image)
                        .resizable()
                        .frame(width: 50, height: 50)
                    Image(item.item.avatar.face.hairStyle)
                        .resizable()
                        .frame(width: 50, height: 50)
                    Image(item.item.avatar.headShape)
                        .resizable()
                        .frame(width: 50, height: 50)
                
                }
               
                Text(item.item.card.name)
                    .padding(.horizontal, 22)
            }
            .frame(width: UIScreen.main.bounds.width / 3, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            
            VStack{
                Text("Quantity: \(String(item.quantity))")
                    .padding(.vertical, 10)
                
                Text("Price: $\(String(item.item.card.price))")
                    .padding(.vertical, 10)
                
            }
            .frame(width: UIScreen.main.bounds.width / 3, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            
            
           // Spacer()
            //Price/Remove/Edit Buttons
            VStack{
                Text("$\(String(item.item.card.price * item.quantity))")
                
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
                        model.getSubTotal()
                        
                    }, label: {
                        Image(systemName: "trash")
                            
                    })
                }
                .foregroundColor(Color("Myscheme"))
                 
            }
            .frame(width: UIScreen.main.bounds.width / 3, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            
        }
        .padding(.leading, 5)
        .padding(.trailing, 9)
                  
        
    }
}

