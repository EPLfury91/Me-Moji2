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
    var Products : [Me_Moji]
    var amount: Int
}

struct address: Codable {
        var line1 : String
        var line2: String
        var postal_code: String
        var state: String
        var city: String
}

//looking to remove since its redundant
struct Product: Codable {
    var item: Me_Moji
    
}

struct Purchased: Codable, Identifiable  {
    var id: UUID
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


//struct paymentIntent {
//    var application_fee_amount: String
//    var last_payment_error: String
//    var transfer_group: String
//    var amount_received: Int
//    var metadata: [String]
//    var on_behalf_of: String
//    
//    var customer: String
//    var payment_method: String
//    var description:  String
//    var processing: String
//    var latest_charge: String
//    var confirmation_method:  String
//    var setup_future_usage: String
//    var automatic_payment_methods: String
//    var statement_descriptor_suffix: String
//    var cancellation_reason: String
//    var amount_capturable: Int
//    var livemode: Bool
//    var payment_method_types: [String]
////        var card: String
////      ]
//    var receipt_email: String
//    var invoice: String
//    var statement_descriptor: String
//    var shipping: String
//    var payment_method_options: [String]
////        var card: [
////          var installments: String
////          var mandate_options: String
////          var network: String
////          var request_three_d_secure: String
////        ]
////      ]
//    var canceled_at: String
//    var amount_details: [String]
////        var tip: [[String]
////      ]
//    var currency: String
//    var transfer_data: String
//    var created: Int
//    var status: String
//    var capture_method:  String
//    var amount: Int
//    var review: String
//    var application: String
//    var id: String
//    var client_secret:  String
//    var next_action: String
//    var object: String
//   
//    
//}
//
