//
//  OrderHistory.swift
//  Me-Moji2
//
//  Created by Brett Tracey on 10/24/23.
//

import SwiftUI

struct OrderHistory: View {
    @EnvironmentObject var model: ContentModel
    @Binding var mainScreen : MainScreen
    
    var body: some View {
        VStack{
            Text("Order History")
            
            if model.FirebasePurchaseDownload.isEmpty == true {
                Text("Loading")
            } else {
                List(model.FirebasePurchaseDownload) { r in
                    NavigationLink {
                        orderDetail(firebaseItem: r)
                    } label: {
                        orderOverview(firebaseItem: r)
                    }
                }
            }
        }
        .onAppear{
            Task{
                try await model.downloadPurchaseHistory()
                model.removeListner()
            }
        }
        .toolbar(content: {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    mainScreen = .Profile
                } label: {
                    Text("Back")
                }

            }
           
        })
    }
      
}

struct orderOverview: View {
    var firebaseItem: FirebasePurchase
    
    var body: some View {
        VStack(alignment: .leading){
            Text("Order Number: \(firebaseItem.id ?? "NO Id")")
            Text("Date: \(firebaseItem.date, style: .date)")
            Text("Amount: $\(String(firebaseItem.amount))")
            
        }
    }
}


struct orderDetail: View {
    var firebaseItem: FirebasePurchase
    
    var body: some View {
        VStack(alignment: .leading){
            Text("Purchase Date: \(firebaseItem.date, style: .date)")
            Text("Shipping Address:")
            FullAddressDisplayView(address: firebaseItem.address)
            
            HStack {
                Text("Total amount: $\(String(firebaseItem.amount))")
            }
            
            Text("Items Purchased:")
            HStack{
                Text("Item")
                    .padding(.horizontal, 20)
                
                Spacer()
                   
                Text("Subtotal")
            }
            .padding(.leading, 15)
            .padding(.trailing, 15)
            
            List(firebaseItem.Products){ index in
                PurchaseHistoryRow(item: index)
                
            }
        }
        .padding(.leading, 5)
    }
}
