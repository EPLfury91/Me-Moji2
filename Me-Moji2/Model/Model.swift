//
//  Model.swift
//  Me-Moji2
//
//  Created by Brett Tracey on 12/7/22.
//

import Foundation
import FirebaseAuth
import SwiftUI
import FirebaseFunctions
import FirebaseFirestore
import FirebaseFirestoreSwift


struct FirebasePurchase: Identifiable, Codable {
    @DocumentID var id: String? = UUID().uuidString
    var date: Date
    var address: address
    var Products : [Purchased]
    var amount: Int
}

struct address: Codable {
        var line1 : String
        var line2: String
        var postal_code: String
        var state: String
        var city: String
}


struct Product: Codable {
   
    var number: Int
    var item: Me_Moji
    
}

struct Purchased: Codable, Identifiable  {
    var id: Int
    var quantity: Int
    var item: Me_Moji
    
    //Need to parse Card datatype
   // var card: Card
}

struct Me_Moji: Codable{
    var avatar : Avatar
    var card : CustomizeItem
}

struct Avatar: Codable{
    var headShape: String
    var hairStyle: String
}


struct CustomizeItem: Identifiable, Codable {
    var id: Int
    var name: String
    var image: String
    var price: Int
    
    //ultimately will be in card
    var caption: String
}

struct FirebaseItem  {
    var FirstName : String
    var HairStyle : String
    var LastName : String
}

struct StripeCustomer {
    var FirstName: String
    var HairStyle: String
    var LastName: String
    var customer_id : String
    var ephemeralKey: String
    var setup_secret: String

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


enum ErrorMessage: Error {
    case NoUserId
}

extension ErrorMessage: CustomStringConvertible, LocalizedError {
    public var description: String {
        switch self {
        case .NoUserId:
            return "No UserId. Please sign out and sign in again"
        }
    }
    
    public var errorDescription: String?{
        switch self{
        case .NoUserId:
            return NSLocalizedString("No User Id. Please sign out and sign in again", comment: "Please sign out and sign in again")
        }
    }
}
