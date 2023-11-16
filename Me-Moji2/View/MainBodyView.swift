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
    case CardChoices
    case CardChoice(cardChoice: String)
    case CardCustomization(itemTapped: Int, eventSelection2: String)
    case Contact
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
                case .OrderHistory: OrderHistory(mainScreen: $mainScreen)
                case .ProfileUpdate: ProfileUpdateView(mainScreen: $mainScreen)
                case .Profile: ProfileView(model: _model, currentScreen: $currentScreen, mainScreen: $mainScreen, screen: $welcomeScreen)
                //case .Card : CustomizationView(model: _model, currentScreen: $mainScreen)
                case .Card :  CardCategoryList(currentScreen: $mainScreen)
                case .CardChoices: CardCategoryList(currentScreen: $mainScreen)
                case .CardChoice(cardChoice: let cardChoice): CategoryCardSelection(model: _model, currentScreen: $mainScreen, eventSelection: cardChoice)
            case .CardCustomization(itemTapped: let itemTapped, eventSelection2: let eventSelection2): CardDetailView(model: _model, currentScreen: $mainScreen,  item: Me_Moji(avatar: Avatar(headShape: model.avatar[0].headShape, face: Face(hairStyle: model.avatar[0].face.hairStyle,eyeBrow: model.avatar[0].face.eyeBrow)), card: model.displayArray[itemTapped]), eventSelection1: eventSelection2)
                case .Contact: ContactUsView()
            }
            
           //keeps menu on bottom of page
           Spacer()
            
            //Menu, should stay on screen
           
        }
        .toolbar{
            ToolbarItem(placement:.bottomBar) {
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
        }
        //.edgesIgnoringSafeArea(.bottom)
        .sheet(isPresented: $model.isPresented, content: {
            WelcomeViewFlow(mainScreen: welcomeScreen)
        })
        .sheet(isPresented: $model.CartTapped) {
            NavigationView {
                FullerCheckoutView(checkoutScreen: .CartView)
            }.environmentObject(MyBackendModel())
        }
        
    }
}

