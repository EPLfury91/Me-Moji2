//
//  ItemDisplayView.swift
//  Me-Moji2
//
//  Created by Brett Tracey on 11/29/22.
//

import SwiftUI

struct ItemDisplayView: View {
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
                    
                    ForEach(0..<30) { index in
                        switch bodyPart {
                        case "eye" :
                            Image("AnimatedFace")
                                .resizable()
                                .scaledToFit()
                        case "ear" :
                            Image(systemName: "ear")
                                .resizable()
                                .scaledToFit()
                        case "nose" :
                            Image(systemName: "nose")
                                .resizable()
                                .scaledToFit()
                        case "heart" :
                            Image(systemName: "heart")
                                .resizable()
                                .scaledToFit()
                            
                        default:
                            Image("AnimatedFace")
                                .resizable()
                                .scaledToFit()
                        }
                       
                    }
                })
                
            }
            .background(.gray)
            .cornerRadius(10)
            
        }
    }
}

struct ItemDisplayView_Previews: PreviewProvider {
    static var previews: some View {
        ItemDisplayView()
    }
}
