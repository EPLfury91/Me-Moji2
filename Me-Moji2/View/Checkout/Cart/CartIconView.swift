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
            Text("\(model.purchased.count) items" )
            
            Text("$ \(model.subtotal)")
            
            Image(systemName: "cart")
                .resizable()
                .frame(width: 25, height: 25)
                .foregroundColor(.blue)
        }
    }
}

struct CartIconView_Previews: PreviewProvider {
    static var previews: some View {
        CartIconView()
    }
}
