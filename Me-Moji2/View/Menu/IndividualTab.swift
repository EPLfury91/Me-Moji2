//
//  IndividualTab.swift
//  Me-Moji2
//
//  Created by Brett Tracey on 5/28/23.
//

import SwiftUI


struct IndividualTab: View {
    
    @State var tabItem: TabItem
    @Binding var isSelected : Int
    
    
    var body: some View {
        
        ZStack{
            RoundedRectangle(cornerRadius: 5)
                .foregroundColor(.white)
                .frame(width: 75, height: 90)
                .opacity(0.15)
            
            VStack{
                tabItem.image
                Text(tabItem.title)
                
            }
            .foregroundColor(isSelected == tabItem.id ? .black : .gray)
            .opacity(isSelected == tabItem.id ? 1.0 : 0.15)

        }     
    
    }
}

