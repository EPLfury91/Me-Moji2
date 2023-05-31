//
//  MainBodyView.swift
//  Me-Moji2
//
//  Created by Brett Tracey on 5/30/23.
//

import SwiftUI

enum MainScreen: Int {
    case Checkout = 0
    case Profile = 1
    case Card = 2
}


struct MainBodyView: View {
    @EnvironmentObject var model: ContentModel
    @State var PickerSelection = 0
    @State var mainScreen : MainScreen = .Card
    @Binding var currentScreen : Screen
    
    var body: some View {
        
        VStack{
            switch mainScreen {
                case .Checkout: CartView()
                case .Profile: ProfileView(model: _model, currentScreen: $currentScreen)
                case .Card : CustomizationView(model: _model, currentScreen: $mainScreen)
            }
            
            Spacer()
            
            //Menu, should stay on screen
            HStack(spacing: 0) {
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
    }
}

