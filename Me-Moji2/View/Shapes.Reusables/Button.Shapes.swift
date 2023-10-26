//
//  Button.Shapes.swift
//  Me-Moji2
//
//  Created by Brett Tracey on 12/3/22.
//

import SwiftUI


struct textOutlineView: View {
    @Binding var inputValue: String
    @State var displayValue : String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .stroke(lineWidth: 2)
                .frame(width: UIScreen.main.bounds.width - 20, height: 50, alignment: .center)
                .foregroundColor(.blue)
            
            
           
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
                .foregroundColor(.blue)
            
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
                .foregroundColor(isDisabled == true ? .gray : .blue)
            
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
                Text(address.line1)
                HStack{
                    Text(address.city)
                       
                    Text(address.state)
                       
                    Text(address.postal_code)
                }
            } else {
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
    var item: Me_Moji
    
    var body: some View {
        HStack(spacing: 10){
            
            ZStack{
                Image(item.avatar.hairStyle)
                    .resizable()
                    .frame(width: 75, height: 75)
                Image(item.card.image)
                    .resizable()
                    .frame(width: 75, height: 75)
                Image(item.avatar.headShape)
                    .resizable()
                    .frame(width: 75, height: 75)
            
            }
            Spacer()
            
            Text(item.card.name)
            
            Spacer()
            
            VStack{
                Text("$\(String(item.card.price))")
                       
            }
            
        }
        
    }
}


