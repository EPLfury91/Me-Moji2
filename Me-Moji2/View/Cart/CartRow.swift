//
//  CartRow.swift
//  Me-Moji2
//
//  Created by Brett Tracey on 12/14/22.
//

import SwiftUI

struct CartRow: View {
    var item: CustomizeItem
    
    var body: some View {
        
        
        HStack(spacing: 10){
            Image(item.image)
                .resizable()
                .frame(width: 75, height: 75)
            Text(item.name)
            Text("$\(String(item.price))")
        }
        
    }
}

