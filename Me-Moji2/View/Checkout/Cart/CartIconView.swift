//
//  CartIconView.swift
//  Me-Moji2
//
//  Created by Brett Tracey on 9/24/23.
//

import SwiftUI

struct CartIconView: View {
    @EnvironmentObject var model : ContentModel
 
    var body: some View {
        HStack{
            VStack {
                Text("\(model.purchased.count) items" )
            
                Text("$ \(model.subtotal)")
            }
            .frame(width: 70, height: 25)
            
            Image(systemName: model.purchased.count > 0 ? "cart.badge.plus": "cart")
                .resizable()
                .frame(width: 25 , height: 25)
                .foregroundColor(Color("Myscheme"))
                
        }
    }
}

