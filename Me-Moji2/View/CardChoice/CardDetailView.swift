//
//  CardDetailView.swift
//  Me-Moji2
//
//  Created by Brett Tracey on 12/8/22.
//

import SwiftUI

struct CardDetailView: View {
    
    var item: Me_Moji
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
                    ZStack{
                        Image(item.card.image)
                            .resizable()
                            .frame(width: 350, height: 350, alignment: .center)
                        Image(item.avatar.hairStyle)
                            .resizable()
                            .frame(width: 350, height: 350, alignment: .center)
                        Image(item.avatar.headShape)
                            .resizable()
                            .frame(width: 350, height: 350, alignment: .center)
                    }
                    
                    ZStack{
                        Image(item.card.image)
                            .resizable()
                            .frame(width: 350, height: 350, alignment: .center)
                        Image(item.avatar.hairStyle)
                            .resizable()
                            .frame(width: 350, height: 350, alignment: .center)
                        Image(item.avatar.headShape)
                            .resizable()
                            .frame(width: 350, height: 350, alignment: .center)
                    }
                   
                   
                }
                .tabViewStyle(.page(indexDisplayMode: .always))
                Divider()
                
                //Description
                Text(item.card.caption)
                
                //Edit Buton
                HStack{
                    Spacer()
                    
                    
                    //MARK: Maybe change to naviagtion link??
                    //Stay in Sheet modifier??
            
                    NavigationLink(destination: {
                        //To do - Navigate to edit section
                        CardWordCustomization(item: item)
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

