//
//  Model.swift
//  Me-Moji2
//
//  Created by Brett Tracey on 12/7/22.
//

import Foundation
import FirebaseAuth
import SwiftUI


struct Purchased: Identifiable {
    var id: UUID
    var item: Me_Moji
    
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


//struct Card:Identifiable, Decodable {
//    var id: Int
//    var text: String
//}


struct Avatar {
    var headShape: String
    var hairStyle: String
}

struct Me_Moji {
    var avatar : Avatar
    var card : CustomizeItem
}

struct FirebaseItem  {
    var FirstName : String
    var HairStyle : String
    var LastName : String
}

struct StripeCustomer {
    var customer_id : String
    var firstName: String
    var setup_secret: String
    var hairStlye: String
    var LastName: String
    
}

struct User2 {
  //  var User = Auth.auth().currentUser
    var FirstName : String
    var LastName: String
}

struct TabItem  {
    var id: Int
    var title : String
    var image: Image
    var identifier: MainScreen
   
}



