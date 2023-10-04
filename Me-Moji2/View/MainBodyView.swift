//
//  MainBodyView.swift
//  Me-Moji2
//
//  Created by Brett Tracey on 5/30/23.
//

import SwiftUI

enum MainScreen {
    case Checkout
    case Profile
    case Card
    case CardChoice
    case CardCustomization(itemTapped: Int)
}


struct MainBodyView: View {
    @EnvironmentObject var model: ContentModel
    @State var PickerSelection = 0
    @State var mainScreen : MainScreen = .Card
    @Binding var currentScreen : Screen
    //@Binding var itemTapped: Int?
   
    @State var welcomeScreen: WelcomeScreenFlow = .Welcome
    
    var body: some View {
        
        VStack{
            switch mainScreen {
                case .Checkout: CartView(isPresented: .constant(false))
                case .Profile: ProfileView(model: _model, currentScreen: $currentScreen, screen: $welcomeScreen)
                case .Card : CustomizationView(model: _model, currentScreen: $mainScreen)
                case .CardChoice: CardChoice(model: _model, currentScreen: $mainScreen)
                case .CardCustomization(itemTapped: let itemTapped): CardDetailView(model: _model, currentScreen: $mainScreen, item: Me_Moji(avatar: Avatar(headShape: model.avatar[0].headShape, hairStyle: model.avatar[0].hairStyle), card: model.item[itemTapped]))
            }
            
            Spacer()
            
            //Menu, should stay on screen
            HStack(spacing: 1) {
                ForEach (TabItemArray, id: \.id)  {item in
                    IndividualTab(tabItem: item, isSelected: $PickerSelection )
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.35)) {
                                PickerSelection = item.id
                                mainScreen = item.identifier
                              
                            }
                        }
                }
            }
        }
        .edgesIgnoringSafeArea(.bottom)
        .sheet(isPresented: $model.isPresented, content: {
            WelcomeView(mainScreen: $welcomeScreen)
        })
    }
}

