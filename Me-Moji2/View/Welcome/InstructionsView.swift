//
//  InstructionsView.swift
//  Me-Moji2
//
//  Created by Brett Tracey on 10/3/23.
//

import SwiftUI

struct InstructionsView: View {
    @Binding var mainscreen : WelcomeScreenFlow
    
    var body: some View {
        VStack{
            Text("You can create, design, and modify your own personal avatar")
            Text("Create a look-a-like, a friend, or whatever you want")
            Text("Then pick a design and you will have your own personal Ava-Card, perfect for any special ocasion")
        }.toolbar(content: {
            Button(action: {
                
            }, label: {
                Text("Next")
            })
        })
    }
       
}


