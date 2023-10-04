//
//  CartIconView.swift
//  Me-Moji2
//
//  Created by Brett Tracey on 9/24/23.
//

import SwiftUI

struct CartIconView: View {
    @EnvironmentObject var model : ContentModel
    @State var scale : Int?
    
    var body: some View {
        HStack{
            VStack {
                Text("\(model.purchased.count) items" )
                    .frame(width: 50 * CGFloat(scale ?? 1), height: 50)
                Text("$ \(model.subtotal)")
                
            }
            
            Image(systemName: "cart")
                .resizable()
                .frame(width: 25 , height: 25)
                .foregroundColor(.blue)
                
        }
    }
}

struct CartIconView_Previews: PreviewProvider {
    static var previews: some View {
        CartIconView()
    }
}
