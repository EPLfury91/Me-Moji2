//
//  CardChoice.swift
//  Me-Moji2
//
//  Created by Brett Tracey on 12/4/22.
//

import SwiftUI

struct CardChoice: View {
    @State var eventSelection = 0
    let column = [GridItem(.flexible(minimum: 60, maximum:120), spacing: 15),
                  GridItem(.flexible(minimum: 60, maximum:120), spacing: 15)]
    
    var body: some View {
        VStack(alignment: .leading){
            
            //TO DO: Why isnt vstack leading alignment??
            HStack{
                Picker("", selection: $eventSelection){
                    Text("Birthday")
                        .tag(0)
                    Text("Anniversary")
                        .tag(1)
                    Text("Christmas")
                        .tag(2)
                }
                .pickerStyle(.menu)
                Spacer()
            }
            
            Spacer()
            ScrollView{
                LazyVGrid(columns: column, content: {
                    //TO DO: Insert reference to cards
                    ForEach(0..<16){item in
                        Image("AnimatedFace")
                            .resizable()
                            .scaledToFit()
                        
                    }
                })
            }
            HStack{
                Spacer()
                Button(action: {
                    
                }, label: {
                    ZStack{
                        Capsule()
                            .frame(width: 200, height: 48, alignment: .center)
                            .foregroundColor(.blue)
                        Text("Continue")
                            .foregroundColor(.white)
                            .font(.subheadline)
                    }
                    
                })
                Spacer()
            }
            
            
            
        }
    }
}

struct CardChoice_Previews: PreviewProvider {
    static var previews: some View {
        CardChoice()
    }
}
