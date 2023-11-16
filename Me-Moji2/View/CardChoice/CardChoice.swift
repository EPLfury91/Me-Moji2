//
//  CardChoice.swift
//  Me-Moji2
//
//  Created by Brett Tracey on 12/4/22.
//

import SwiftUI



//List all different categories of cards
struct CardCategoryList: View {
    @Binding var currentScreen : MainScreen
    var choices = ["Birthday","Anniversary", "Christmas", "Save the Date"]
    
    var body: some View {
        List(choices, id: \.self){index in
            Button {
                currentScreen = .CardChoice(cardChoice: index)
             } label: {
                Text(index)
            }
           
        }
            .foregroundColor(Color("Myscheme"))
    }
}


//after selecting category, display all cards within the category
struct CategoryCardSelection: View {
    @EnvironmentObject var model : ContentModel
    @State var itemTapped = 0
    @State var isTapped = false
    @State var mainScreen : MainScreen = .CardChoices
    @Binding var currentScreen : MainScreen
    @State var eventSelection = "Birthday"
    
    let column = [GridItem(.flexible(minimum: 60, maximum:UIScreen.main.bounds.width - 15), spacing: 7),
                  GridItem(.flexible(minimum: 60, maximum:UIScreen.main.bounds.width - 15), spacing: 7)]
    
    var body: some View {
       VStack(alignment: .leading){
            ScrollView {
                //List of Cards
                LazyVGrid(columns: column, content: {
                    //TO DO: Insert reference to cards
                    ForEach(0..<model.displayArray.count, id: \.self){ index in
                        
                        Button {
                            currentScreen = .CardCustomization(itemTapped : index, eventSelection2 : eventSelection )
                        } label: {
                            ZStack{
                                Rectangle()
                                        .stroke(lineWidth: 3)
                                        .frame(height: 210)
                                        .foregroundColor(itemTapped == index ? Color("Myscheme") : .blue)
                            
                                        Image(model.displayArray[index].image)
                                            .resizable()
                                            .scaledToFit()
                            
                                Image(model.avatar[0].face.hairStyle)
                                            .resizable()
                                            .frame(width: 25, height: 25)
                            }
                        }
                        .tag(index)
                    }
                })
            }
        }
       .onAppear(perform: {
           model.createCardArray(selection: eventSelection )
       })
        
       .toolbar {
           ToolbarItem(placement: ToolbarItemPlacement.navigationBarLeading) {
                Button {
                    currentScreen = .CardChoices
                } label: {
                    Image(systemName: "chevron.backward")
                    Text("Back")
                }
           }
           
           ToolbarItem(placement: ToolbarItemPlacement.navigationBarTrailing) {
               Button {
                   model.CartTapped = true
               } label: {
                    CartIconView()
                      
               }
           }
       }
       .foregroundColor(Color("Myscheme"))
        
    }
       
}

