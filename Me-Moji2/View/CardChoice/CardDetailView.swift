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
    @State var quantity = 1
    var item: Me_Moji?
    var eventSelection1 : String?
    
    
    var body: some View {
    ScrollView{
        VStack(alignment: .leading){
            Text(item!.card.name)
                .font(.subheadline)
            Text(eventSelection1 ?? "Birthday")
                .font(.headline)
                .bold()
            

            //Detailed view of Card
            TabView{
                ZStack{
                    Image(item!.card.image)
                        .resizable()
                        .frame(width: 75, height: 75, alignment: .center)
                    Image(item!.avatar.face.hairStyle)
                        .resizable()
                        .frame(width: 350, height: 350, alignment: .center)
                    Image(item!.avatar.headShape)
                        .resizable()
                        .frame(width: 75, height: 75, alignment: .center)
                    Image(item!.avatar.face.eyeBrow)
                        .resizable()
                        .frame(width: 75, height: 75, alignment: .center)
                    
                }
                
                ZStack{
                    
                    Image(item!.avatar.face.hairStyle)
                        .resizable()
                        .frame(width: 50, height: 50, alignment: .center)
                    Image(item!.avatar.headShape)
                        .resizable()
                        .frame(width: 50, height: 50, alignment: .center)
                    Image(item!.avatar.face.eyeBrow)
                        .resizable()
                        .frame(width: 70, height: 15, alignment: .center)
                        .offset(x: CGFloat(item!.card.eyePlacex), y: CGFloat(item!.card.eyePlacey))
                    Image(item!.card.image)
                        .resizable()
                        .frame(width: 350, height: 350, alignment: .center)
                }.background(Color.secondary)
                
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 2, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            Divider()
            
            //Description
            Text(item!.card.caption + "!")
            Text("From $" + String(item!.card.price) + "ea")
            
            Divider()
            
            //Picker for Quanity
            VStack{
                Text("Quantity")
                
                Picker("", selection: $quantity) {
                    ForEach(1..<150){ index in
                        Text(String(index))
                            .foregroundColor((Color("Myscheme")))
                            .tag(index)
                    }
                }
               
                .pickerStyle(.menu)
            }
            
            Divider()
            
            //Edit Buton
            
            VStack{
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
                        model.purchased.append(Purchased(id: item!.card.id, quantity: quantity, item: item!))
                        model.getSubTotal()
                        self.scale = 5
                        
                    }, label: {
                        buttonDisplay(buttonLabel: "Add to Cart")
                    })
                    
                    Spacer()
                }
            }    
            
            Divider()
            //Shipping
            NavigationLink {
                Text("All our items are shipped by the close of the next business day by standard USPS mail.")
            } label: {
                Text("Shipping")
            }
            .navigationTitle("Shipping")
            
            //Returns
            NavigationLink {
                Text("While we can't except returns, we will work with you to make sure you are fully satisfied with your order")
            } label: {
                Text("Return")
            }
            .navigationTitle("Return")
        }
    }
            .foregroundColor(Color("Myscheme"))
        .toolbar {
            ToolbarItem(placement:ToolbarItemPlacement.navigationBarLeading) {
                Button {
                   
                    currentScreen = .CardChoice(cardChoice: eventSelection1 ?? "Birthday")
                } label: {
                    Image(systemName: "chevron.backward")
                    Text("Back")
                }
            }
            
            ToolbarItem(placement: ToolbarItemPlacement.navigationBarTrailing) {
                Button {
                    model.CartTapped = true
                } label: {
                    HStack {
                        CartIconView()
                    }
                    
                }
            }
            
        }
            .foregroundColor(Color("Myscheme"))
    }
}

