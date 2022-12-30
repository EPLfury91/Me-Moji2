//
//  Model.swift
//  Me-Moji2
//
//  Created by Brett Tracey on 12/7/22.
//

import Foundation


struct Purchased: Identifiable, Decodable {
    var id: UUID
    var item: CustomizeItem
    
    //Need to parse Card datatype
   // var card: Card
    
}

struct CustomizeItem: Identifiable, Decodable {
    var id: Int
    var name: String
    var image: String
    var price: Int
    
    //ultimately will be in card
    var caption: String
}


struct Card:Identifiable, Decodable {
    var id: Int
    var text: String
}

