//
//  CardWordCustomization.swift
//  Me-Moji2
//
//  Created by Brett Tracey on 12/22/22.
//

import SwiftUI

struct CardWordCustomization: View {
    
    //Need to switch to card item
    var item: Me_Moji
    @State var CustomText = ""
    var body: some View {
        VStack{
            
            ZStack{
                Image(item.card.image)
                    .resizable()
                    .frame(width: 200, height: 200)
                Image(item.avatar.headShape)
                    .resizable()
                    .frame(width: 200, height: 200)
                Image(item.avatar.hairStyle)
                    .resizable()
                    .frame(width: 200, height: 200)
            }
            
            
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(lineWidth: 2)
                    .frame(width: UIScreen.main.bounds.width - 20, height: 50, alignment: .center)
                    .foregroundColor(.blue)
                
                TextField("Enter Custom Text here", text: $CustomText)
                    .foregroundColor(.primary)
                    .padding(.horizontal)
            }
                .padding()
            }
        
    }
}


