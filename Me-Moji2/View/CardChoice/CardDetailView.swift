//
//  CardDetailView.swift
//  Me-Moji2
//
//  Created by Brett Tracey on 12/8/22.
//

import SwiftUI

struct CardDetailView: View {
    @EnvironmentObject var model : ContentModel
    @Binding var currentScreen : MainScreen
    @State var isTapped : Bool = false
    @State var scale = 1
    var item: Me_Moji?
    
    var body: some View {
        VStack(alignment: .leading){
            
            //Detailed view of Card
            TabView{
                ZStack{
                    
                    Image(item!.avatar.hairStyle)
                        .resizable()
                        .frame(width: 350, height: 350, alignment: .center)
                    Image(item!.avatar.headShape)
                        .resizable()
                        .frame(width: 75, height: 75, alignment: .center)
                    Image(item!.card.image)
                        .resizable()
                        .frame(width: 75, height: 75, alignment: .center)
                }
                
                ZStack{
                    Image(item!.card.image)
                        .resizable()
                        .frame(width: 350, height: 350, alignment: .center)
                    Image(item!.avatar.hairStyle)
                        .resizable()
                        .frame(width: 50, height: 50, alignment: .center)
                    Image(item!.avatar.headShape)
                        .resizable()
                        .frame(width: 50, height: 50, alignment: .center)
                }
                
                
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
            Divider()
            
            //Description
            Text(item!.card.caption)
            
            //Edit Buton
            HStack{
                Spacer()
                
                //MARK: Maybe change to naviagtion link??
                //Stay in Sheet modifier??
                
                
                NavigationLink(destination: {
                    //To do - Navigate to edit section
                    CardWordCustomization(item: item!)
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
                    //MARK: Need to update once a quantiy option has been added
                    model.purchased.append(Purchased(id: 1, quantity: 4, item: item!))
                    model.getSubTotal()
                    self.scale = 5
                    
                }, label: {
                    buttonDisplay(buttonLabel: "Add to Cart")
                })
                
                Spacer()
            }
            
        }
        .toolbar {
            ToolbarItem(placement:ToolbarItemPlacement.navigationBarLeading, content: {
                    Button {
                        currentScreen = .CardChoice
                    } label: {
                        Image(systemName: "chevron.backward")
                        Text("Back")
                    }
            })
            ToolbarItem(placement: ToolbarItemPlacement.navigationBarTrailing) {
                
                Button {
                    model.CartTapped = true
                } label: {
                    HStack {
                        CartIconView(scale: self.scale)
                    }
                    
                }
            }
            
        }
    }
}

