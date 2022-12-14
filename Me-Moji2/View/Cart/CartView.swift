//
//  CartView.swift
//  Me-Moji2
//
//  Created by Brett Tracey on 12/13/22.
//

import SwiftUI

struct CartView: View {
    var item:CustomizeItem
    var body: some View {
        VStack(alignment: .leading){
            CartRow(item: item)
        }
    }
}

