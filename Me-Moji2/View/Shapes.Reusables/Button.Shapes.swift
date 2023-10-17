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

struct AddressDisplayView: View {
    var text: String
    var body: some View {
        ZStack{
//            RoundedRectangle(cornerRadius: 10)
//                .stroke(.gray)
//                .frame(width: UIScreen.main.bounds.width / 1.05 , height: 20, alignment: .center)
//                .foregroundColor(.black)
            
            Text(text)
                .font(.subheadline)
                .foregroundColor(.white)
                .padding(.leading)
        }
    }
}

