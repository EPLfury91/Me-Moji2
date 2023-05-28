//
//  IndividualTab.swift
//  Me-Moji2
//
//  Created by Brett Tracey on 5/28/23.
//

import SwiftUI


struct IndividualTab: View {
    
    @State var tabItem: TabItem
    
    var body: some View {
        
        ZStack{
            RoundedRectangle(cornerRadius: 5)
                .foregroundColor(.gray)
                .frame(width: 70, height: 75)
                .opacity(0.05)
            
            VStack{
                tabItem.image
                Text(tabItem.title)
                
            }
        }
    
       
        
    
    }
}

