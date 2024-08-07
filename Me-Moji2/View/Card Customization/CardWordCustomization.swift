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
    @State var name1 = ""
    @State var name2 = ""
    @State var date = ""
    @State var Location = ""
    
    var body: some View {
        VStack{
            
            ZStack{
                Image(item.card.image)
                    .resizable()
                    .frame(width: 200, height: 200)
                Image(item.avatar.headShape)
                    .resizable()
                    .frame(width: 200, height: 200)
                Image(item.avatar.face.hairStyle)
                    .resizable()
                    .frame(width: 200, height: 200)
            }
            
            
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(lineWidth: 2)
                    .frame(width: UIScreen.main.bounds.width - 20, height: 50, alignment: .center)
                    .foregroundColor(.blue)
                
                TextField("Name 1", text: $name1)
                    .foregroundColor(.primary)
                    .padding(.horizontal)
            }
            .padding()
            
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(lineWidth: 2)
                    .frame(width: UIScreen.main.bounds.width - 20, height: 50, alignment: .center)
                    .foregroundColor(.blue)
                
                TextField("Name 2", text: $name2)
                    .foregroundColor(.primary)
                    .padding(.horizontal)
            }
            .padding()
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(lineWidth: 2)
                    .frame(width: UIScreen.main.bounds.width - 20, height: 50, alignment: .center)
                    .foregroundColor(.blue)
                
                TextField("Enter Date", text: $date)
                    .foregroundColor(.primary)
                    .padding(.horizontal)
            }
            .padding()
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(lineWidth: 2)
                    .frame(width: UIScreen.main.bounds.width - 20, height: 50, alignment: .center)
                    .foregroundColor(.blue)
                
                TextField("Enter Location", text: $Location)
                    .foregroundColor(.primary)
                    .padding(.horizontal)
            }
            .padding()
            
        }
    }
}


