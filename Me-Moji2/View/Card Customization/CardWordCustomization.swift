//
//  CardWordCustomization.swift
//  Me-Moji2
//
//  Created by Brett Tracey on 12/22/22.
//

import SwiftUI

struct CardWordCustomization: View {
    
    //Need to switch to card item
    var item: CustomizeItem
    @State var CustomText = ""
    var body: some View {
        VStack{
            Image(item.image)
                .resizable()
                .frame(width: 200, height: 200)
            
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


