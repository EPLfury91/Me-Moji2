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
    
    
    var body: some View {
        VStack(alignment: .leading){
            
            Text("Hello, \(Auth.auth().currentUser?.displayName ?? "NOT THERE")")
            
            //Delete Button
            Button {
                model.deleteUser()
            } label: {
                Text("Delete User")
            }
            
            //Sign Out Button
            Button {
                model.SignOut()
                if Auth.auth().currentUser == nil {
                    currentScreen = .Login
                }
            } label: {
                Text("Sign out")
            }
            
            Button {
                //Add code to display purchase history
            } label: {
                Text("Order History")
            }
            
            
        }
    }
}
