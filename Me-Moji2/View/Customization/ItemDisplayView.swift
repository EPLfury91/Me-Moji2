//
//  ItemDisplayView.swift
//  Me-Moji2
//
//  Created by Brett Tracey on 11/29/22.
//

import SwiftUI

struct ItemDisplayView: View {
    @EnvironmentObject var model : ContentModel
    @State var bodyPart = "eye"
    
    let columns = [GridItem(.fixed(60), spacing: 10),
                   GridItem(.fixed(60), spacing: 10)]
    
    var body: some View {
        
        VStack(spacing: 0){
            Picker("", selection: $bodyPart) {
                Image(systemName: "eye")
                    .tag("eye")
                Image(systemName: "ear")
                    .tag("ear")
                Image(systemName: "nose")
                    .tag("nose")
                Image(systemName: "heart")
                    .tag("heart")
            }
            .pickerStyle(.segmented)
            
            
            ScrollView(.horizontal) {
                LazyHGrid(rows: columns, content: {
                    
                    
                    ForEach(model.HairStyle, id: \.self) { i in
                            Button(action: {
                                model.avatar[0].hairStyle = i
                            }, label: {
                                Image(i)
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                
                            })
                        }
                    })
                    
            }
            .background(.white)
            .cornerRadius(10)
            
        }
    }
}

