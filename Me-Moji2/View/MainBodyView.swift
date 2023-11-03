//
//  MainBodyView.swift
//  Me-Moji2
//
//  Created by Brett Tracey on 5/30/23.
//

import SwiftUI

enum MainScreen {
    case Checkout
    case OrderHistory
    case ProfileUpdate
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
    @State var welcomeScreen: WelcomeScreenFlow = .Welcome
    
    var body: some View {
        
        VStack(spacing: 0){
            switch mainScreen {
                case .Checkout: FullerCheckoutView()
                case .OrderHistory: OrderHistory()
                case .ProfileUpdate: ProfileUpdateView()
                case .Profile: ProfileView(model: _model, currentScreen: $currentScreen, mainScreen: $mainScreen, screen: $welcomeScreen)
                case .Card : CustomizationView(model: _model, currentScreen: $mainScreen)
                case .CardChoice: CardChoice(model: _model, currentScreen: $mainScreen)
                case .CardCustomization(itemTapped: let itemTapped): CardDetailView(model: _model, currentScreen: $mainScreen, item: Me_Moji(avatar: Avatar(headShape: model.avatar[0].headShape, hairStyle: model.avatar[0].hairStyle), card: model.item[itemTapped]))
            }
            
           //keeps menu on bottom of page
           Spacer()
            
            //Menu, should stay on screen
            HStack(spacing: 1) {
                ForEach (TabItemArray, id: \.id)  {item in
                    IndividualTab(tabItem: item, isSelected: $PickerSelection )
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.35)) {
                                if item.id == 1 {
                                    model.CartTapped = true
                                } else {
                                    PickerSelection = item.id
                                    mainScreen = item.identifier
                                }
                            }
                        }
                }
            }
        }
        .edgesIgnoringSafeArea(.bottom)
        .sheet(isPresented: $model.isPresented, content: {
            WelcomeViewFlow(mainScreen: welcomeScreen)
        })
        .sheet(isPresented: $model.CartTapped) {
            NavigationView {
                CartView(isPresented: $model.CartTapped)
                    
            }.environmentObject(MyBackendModel())
        }
        
    }
}

