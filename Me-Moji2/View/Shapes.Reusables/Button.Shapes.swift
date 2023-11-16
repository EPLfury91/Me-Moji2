//
//  Button.Shapes.swift
//  Me-Moji2
//
//  Created by Brett Tracey on 12/3/22.
//

import SwiftUI
import Stripe
import StripePaymentSheet


struct textOutlineView: View {
    @Binding var inputValue: String
    @State var displayValue : String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .stroke(lineWidth: 2)
                .frame(width: UIScreen.main.bounds.width - 20, height: 50, alignment: .center)
                .foregroundColor(Color("Myscheme"))
   
            TextField(text:$inputValue, prompt: Text("\(displayValue)")) {
                Text("\(displayValue)")
                    .foregroundColor(.primary)
            }
            .padding()
            .autocorrectionDisabled(true)
        }
    }
}

struct SecureOutlineView: View {
    @Binding var inputValue: String
    @State var displayValue : String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .stroke(lineWidth: 2)
                .frame(width: UIScreen.main.bounds.width - 20, height: 50, alignment: .center)
                .foregroundColor(Color("Myscheme"))
            
            SecureField(text:$inputValue, prompt: Text("\(displayValue)")){
                Text("\(displayValue)")
                    .foregroundColor(.blue)
            }
            .padding()
        }
    }
}

struct buttonDisplay: View {
    
    var buttonLabel = ""
    var isDisabled = false
    
    var body: some View {
        ZStack{
            Capsule()
                .frame(width: UIScreen.main.bounds.width / 2.3 , height: 50, alignment: .center)
                .foregroundColor(isDisabled == true ? .gray : Color("Myscheme"))
            
            Text(buttonLabel)
                .font(.subheadline)
                .foregroundColor(.white)
        }
    }
}

struct FullAddressDisplayView: View {
    var address: address
    
    var body: some View {
        VStack(alignment: .leading){
            
            if address.line2 == "" {
                Text(address.name)
                Text(address.line1)
                HStack{
                    Text(address.city)
                       
                    Text(address.state)
                       
                    Text(address.postal_code)
                }
            } else {
                Text(address.name)
                Text(address.line1)
                Text(address.line2)
                HStack{
                    Text(address.city)
                       
                    Text(address.state)
                       
                    Text(address.postal_code)
                }
            }
        }
        .font(.subheadline)
        .foregroundColor(.white)
        .padding(.leading)
    }
}

struct FullAddressDisplayViewStripe: View {
    var address: AddressViewController.AddressDetails.Address?
    var name : String
    
    var body: some View {
        VStack(alignment: .leading){
            if address?.line2 == nil {
                Text(name)
                Text(address?.line1 ?? "")
                HStack{
                    Text(address?.city ?? "")
                       
                    Text(address?.state ?? "")
                       
                    Text(address?.postalCode ?? "")
                }
            } else {
                Text(name)
                Text(address?.line1 ?? "")
                Text(address?.line2 ?? "")
                HStack{
                    Text(address?.city ?? "")
                       
                    Text(address?.state ?? "")
                       
                    Text(address?.postalCode ?? "")
                }
            }
        }
        .font(.subheadline)
        .foregroundColor(.white)
        .padding(.leading)
    }
}


struct AddressDisplayView: View {
    var text: String
    var body: some View {
        ZStack{
            
            Text(text)
                .font(.subheadline)
                .foregroundColor(.white)
                .padding(.leading)
        }
    }
}


struct PurchaseHistoryRow: View {
    @EnvironmentObject var model: ContentModel
    var item: Purchased
    
    var body: some View {
        HStack(spacing: 3){
            VStack{
                ZStack{
                    Image(item.item.avatar.headShape)
                        .resizable()
                       
                    Image(item.item.card.image)
                        .resizable()
                        
                    Image(item.item.avatar.headShape)
                        .resizable()
                
                }
                .frame(width: UIScreen.main.bounds.width / 7, height: 50)
                
                Text(item.item.card.caption)
                    .fontWeight(.medium)
                    .frame(width: UIScreen.main.bounds.width / 3, height: 40)
                    .multilineTextAlignment(.center)
                   
            }
            
            Spacer()
            VStack{
                Text("Quantity: \(String(item.quantity))")
                    .padding(.vertical, 15)
               
                Text(String("Price $\(item.item.card.price)"))
            }
            .font(.caption)
            .padding(.vertical, 15)
            .frame(width: UIScreen.main.bounds.width / 4, height: 60)
            
            
            Spacer()
            
            Text("$\(String(item.item.card.price * item.quantity))")
                .frame(width: UIScreen.main.bounds.width / 12, height: 60)
                
        }
        
    }
}


