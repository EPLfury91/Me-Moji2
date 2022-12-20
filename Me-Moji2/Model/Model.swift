//
//  Model.swift
//  Me-Moji2
//
//  Created by Brett Tracey on 12/7/22.
//

import Foundation


struct CustomizeItem: Identifiable, Decodable {
    var id: Int
    var name: String
    var image: String
    var price: Int
}

struct Purchased: Identifiable, Decodable {
    var id: UUID
    var item: CustomizeItem
    
}

