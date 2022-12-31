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
            
            TextField(text:$inputValue, prompt: Text("\(displayValue)")){
                Text("\(displayValue)")
                    .foregroundColor(.primary)
            }
            .padding()
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
                    .foregroundColor(.primary)
            }
            .padding()
        }
    }
}

struct buttonDisplay: View {
    
    var buttonLabel = ""
    
    var body: some View {
        ZStack{
            Capsule()
                .frame(width: UIScreen.main.bounds.width / 2.5 , height: 50, alignment: .center)
                .foregroundColor(.blue)
            
            Text(buttonLabel)
                .font(.subheadline)
                .foregroundColor(.white)
        }
    }
}

