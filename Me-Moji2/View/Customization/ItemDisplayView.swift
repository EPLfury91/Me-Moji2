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
                    
//                    ForEach(model.item) { index in
//
//                        Button(action: {
//
//                        }, label: {
//                            Image(index.image)
//                                .resizable()
//                                .frame(width: 50, height: 50)
//                        })
//
//                    }
                    
                    
                    //playing around with
                    
                    
                    
                    Button(action: {
                        model.avatar[0].hairStyle = "AnimatedFace"
                    }, label: {
                        Image("AnimatedFace")
                            .resizable()
                            .frame(width: 50, height: 50)
                            
                    })
                   
                    
                    Button(action: {
                        model.avatar[0].hairStyle = "LongHair1"
                    }, label: {
                        Image("LongHair1")
                            .resizable()
                            .frame(width: 50, height: 50)
                    })
                  
                    
                    
                    
                    Button(action: {
                        model.avatar[0].hairStyle = "LongHair1"
                    }, label: {
                        Image("LongHair1")
                            .resizable()
                            .frame(width: 50, height: 50)
                    })
                  
                    
                    Button(action: {
                        model.avatar[0].hairStyle = "ShortHair1"
                    }, label: {
                        Image("ShortHair1")
                            .resizable()
                            .frame(width: 50, height: 50)
                    })
                   
                    
                    
                    
                    /*    switch bodyPart {
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
                       
                    }*/
                })
                
            }
            .background(.white)
            .cornerRadius(10)
            
        }
    }
}

