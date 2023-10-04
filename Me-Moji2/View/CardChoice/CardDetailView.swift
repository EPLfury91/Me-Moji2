//
//  CardDetailView.swift
//  Me-Moji2
//
//  Created by Brett Tracey on 12/8/22.
//

import SwiftUI

struct CardDetailView: View {
    @EnvironmentObject var model : ContentModel
   // @State var mainScreen : MainScreen = .CardChoice
    @Binding var currentScreen : MainScreen
    var item: Me_Moji?
    @State var isTapped : Bool = false
    @State var scale = 1
    
    var body: some View {
        VStack(alignment: .leading){
            HStack{
                //Back Button
                Button(action: {
                    //  self.isTapped.toggle()
                    currentScreen = .CardChoice
                }, label: {
                    HStack{
                        Image(systemName: "chevron.backward")
                        Text("Back")
                    }
                })
                .padding()
                
                Spacer()
                
                //Cart Button
                
                Button {
                    isTapped.toggle()
//                    currentScreen   = .Checkout
                } label: {
                    CartIconView()
                        .frame(width: 100, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
                }
                .padding()
                
              
            }
            
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
                    model.purchased.append(Purchased(id: UUID(), item: item!))
                    model.getSubTotal()
                    self.scale 
                    
                }, label: {
                    buttonDisplay(buttonLabel: "Add to Cart")
                })
                
                Spacer()
            }
            
        }
        .sheet(isPresented: $isTapped) {
            NavigationView {

                CartView(isPresented: $isTapped)
            }
            
        }
        
    }
}

