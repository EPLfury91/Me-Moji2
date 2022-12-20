//
//  CardDetailView.swift
//  Me-Moji2
//
//  Created by Brett Tracey on 12/8/22.
//

import SwiftUI

struct CardDetailView: View {
    
    var item: CustomizeItem
    @EnvironmentObject var model : ContentModel
    @Binding var isTapped : Bool
    
    var body: some View {
        NavigationView{
            VStack(alignment: .leading){
                HStack{
                    
                    //Back Button
                    Button(action: {
                        self.isTapped.toggle()
                    }, label: {
                        HStack{
                            Image(systemName: "chevron.backward")
                            Text("Back")
                        }
                        
                    })
                    .padding()
                    
                    Spacer()
                    
                    //Cart Button
                    NavigationLink(destination: {
                            CartView()
                    }, label: {
                            Image(systemName: "cart")
                                .resizable()
                                .frame(width: 25, height: 25)
                                .foregroundColor(.blue)
                    })
                        .padding()
                }
                
                //Detailed view of Card
                TabView{
                    Image(item.image)
                        .resizable()
                        .scaledToFit()
                    Image(item.image)
                        .resizable()
                        .scaledToFit()
                }
                .tabViewStyle(.page(indexDisplayMode: .always))
                Divider()
                
                //Description
                Text("This card is a \(item.name) of a good time")
                
                //Edit Buton
                HStack{
                    Spacer()
                    
                    Button(action: {
                        //Add action
                        
                    }, label: {
                        buttonDisplay(buttonLabel: "Edit")
                    })
                    
                    Spacer()
                }
                
                //Add to Cart
                HStack{
                    Spacer()
                    
                    Button(action: {
                        //Action
                        model.purchased.append(Purchased(id: UUID(), item: item))
                    }, label: {
                       buttonDisplay(buttonLabel: "Add to Cart")
                    })
                    
                    Spacer()
                }
                
            }
        }
        
        
    }
}

