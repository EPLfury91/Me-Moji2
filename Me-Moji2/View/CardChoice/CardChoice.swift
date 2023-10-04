//
//  CardChoice.swift
//  Me-Moji2
//
//  Created by Brett Tracey on 12/4/22.
//

import SwiftUI

struct CardChoice: View {
    @EnvironmentObject var model : ContentModel
    @State var eventSelection = 0
    @State var itemTapped = 0
   // @State var isTapped = false
    @State var mainScreen : MainScreen = .CardChoice
    @Binding var currentScreen : MainScreen
    
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
           
            ScrollView {

                //List of Cards
                LazyVGrid(columns: column, content: {
                    //TO DO: Insert reference to cards
                    ForEach(0..<model.item.count){ index in
                        
                        Button {
                            currentScreen = .CardCustomization(itemTapped : index)
                        } label: {
                            ZStack{
                                Rectangle()
                                        .stroke(lineWidth: 3)
                                        .frame(height: 120)
                                        .foregroundColor(itemTapped == index ? .black : .blue)
                            
                                        Image(model.item[index].image)
                                            .resizable()
                                            .scaledToFit()
                            
                                        Image(model.avatar[0].hairStyle)
                                            .resizable()
                                            .frame(width: 25, height: 25)
                                                        }
                        }
                        
//                        NavigationLink {
//                            CardDetailView(item: Me_Moji(avatar: Avatar(headShape: model.avatar[0].headShape, hairStyle: model.avatar[0].hairStyle), card: model.item[itemTapped]))
//                        } label: {
//                            ZStack{
//                                Rectangle()
//                                    .stroke(lineWidth: 3)
//                                    .frame(height: 120)
//                                    .foregroundColor(itemTapped == index ? .black : .blue)
//
//                                Image(model.item[index].image)
//                                    .resizable()
//                                    .scaledToFit()
//
//                                Image(model.avatar[0].hairStyle)
//                                    .resizable()
//                                    .frame(width: 25, height: 25)
//                            }
//                        }

                       
//                        Button(action: {
//                            self.itemTapped = index
//                           // isTapped = true
//
//                        }, label: {
//                            ZStack{
//                                Rectangle()
//                                    .stroke(lineWidth: 3)
//                                    .frame(height: 120)
//                                    .foregroundColor(itemTapped == index ? .black : .blue)
//
//                                Image(model.item[index].image)
//                                    .resizable()
//                                    .scaledToFit()
//
//                                Image(model.avatar[0].hairStyle)
//                                    .resizable()
//                                    .frame(width: 25, height: 25)
//                            }
//
//                        })
                        .tag(index)
                    }
                })
            }
           
           //Continue Button
            HStack{
                Spacer()
                
                Button(action: {
                    //currentScreen = .Checkout
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
       .toolbar {
           ToolbarItem(placement:ToolbarItemPlacement.navigationBarLeading, content: {
                   Button {
                       currentScreen = .Card
                   } label: {
                       Image(systemName: "chevron.backward")
                       Text("Back")
                   }
           })
           ToolbarItem(placement: ToolbarItemPlacement.navigationBarTrailing) {
               
               Button {
                   //currentScreen = .Checkout
               } label: {
                   HStack {
                       CartIconView()
                   }
                   
               }    
           }
           
       }
        
    }
}

