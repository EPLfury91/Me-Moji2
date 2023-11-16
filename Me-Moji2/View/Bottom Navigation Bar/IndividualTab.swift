//
//  IndividualTab.swift
//  Me-Moji2
//
//  Created by Brett Tracey on 5/28/23.
//

import SwiftUI

//Bottom Navigation Bar
struct IndividualTab: View {
    
    @State var tabItem: TabItem
    @Binding var isSelected : Int
    
    var body: some View {
        ZStack {
            
            RoundedRectangle(cornerRadius: 8)
                .frame(width: UIScreen.main.bounds.width / 4, height: UIScreen.main.bounds.height / 9.7)
                .background(Color.primary)
                .opacity(isSelected == tabItem.id ? 1.0 : 0.15)
            
            //Display Image and ords
            VStack{
                tabItem.image
                Text(tabItem.title)
                
            }
            .foregroundColor(isSelected == tabItem.id ? .black : .gray)
            
        }
        .edgesIgnoringSafeArea(.all)
    }
}

