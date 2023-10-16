//
//  InstructionsView.swift
//  Me-Moji2
//
//  Created by Brett Tracey on 10/3/23.
//

import SwiftUI

struct InstructionsView: View {
    @EnvironmentObject var model: ContentModel
    @Binding var mainscreen : WelcomeScreenFlow
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5.0){
            Text("Create, design, and modify your own personal avatar")
            Text("Create a look-a-like, a friend, or whatever you want")
            Text("Then pick a card design and you will have your own personal Ava-Card, perfect for any special ocasion")
            
            
            HStack{
                Spacer()
                Button(action: {
                    model.isPresented = false
                }, label: {
                    Text("Get Started!")
                })
                Spacer()
                
            }
            
        }
        .toolbar(content: {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    mainscreen = .Welcome
                }, label: {
                    Text("Back")
                })
            } 
        })
    }
       
}


