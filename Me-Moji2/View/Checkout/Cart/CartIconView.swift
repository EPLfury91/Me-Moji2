//
//  CartIconView.swift
//  Me-Moji2
//
//  Created by Brett Tracey on 9/24/23.
//

import SwiftUI

struct CartIconView: View {
    @EnvironmentObject var model : ContentModel
    @State var scale : Int = 1
    
    var body: some View {
        HStack{
            VStack {
                //scale updated when add to cart button clicked in card detail view
                Text("\(model.purchased.count) items" )
                    .animation(.spring(), value: self.scale)
                Text("$ \(model.subtotal)")
                
            }
            .frame(width: 70 * CGFloat(scale), height: 25)
            
            Image(systemName: "cart")
                .resizable()
                .frame(width: 25 , height: 25)
                .foregroundColor(.blue)
                
        }
    }
}

