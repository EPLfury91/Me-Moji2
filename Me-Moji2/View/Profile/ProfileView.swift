//
//  ProfileView.swift
//  Me-Moji2
//
//  Created by Brett Tracey on 5/30/23.
//

import SwiftUI
import FirebaseAuth

struct ProfileView: View {
    @EnvironmentObject var model: ContentModel
    @Binding var currentScreen : Screen
    @Binding var screen: WelcomeScreenFlow
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 7){
            
            Text("Hello, \(Auth.auth().currentUser?.displayName ?? "NOT THERE")")
            
            //Sign Out Button
            
            
            Button {
                //Add code to display purchase history
            } label: {
                Text("Update Account Info")
            }
            
            NavigationLink {
                WelcomeView(mainScreen: $screen)
            } label: {
                Text("Welcome Instructions")
            }

            
            Button {
                //Add code to display purchase history
            } label: {
                Text("Order History")
            }
           
            Button {
                model.SignOut()
                if Auth.auth().currentUser == nil {
                    currentScreen = .Login
                }
            } label: {
                Text("Sign out")
            }
            
            //Delete Button
            Button {
                model.deleteUser()
            } label: {
                Text("Delete User")
            }
            
            
        }
    }
}
