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
    @Binding var mainScreen : MainScreen
    @Binding var screen: WelcomeScreenFlow
    @State var isPresented = false
    @State var DeleteisPresented = false
    
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 7){
            
            Text("Hello, \(Auth.auth().currentUser?.displayName ?? "NOT THERE")")
 
            Button {
                mainScreen = .ProfileUpdate
            } label: {
                Text("Update Account Info")
            }
            
           Button {
               model.dismissSheet()
            } label: {
                Text("Welcome Instructions")
            }

            
            Button {
                mainScreen = .OrderHistory
            } label: {
                Text("Order History")
            }
            
    Divider()
            
    //Sign Out Button
            //MARK: Add promt to confirm
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
                DeleteisPresented = true
            } label: {
                Text("Delete Account")
            }
            .confirmationDialog("Are you sure you want to delete?", isPresented: $DeleteisPresented) {
                Button {
                    model.deleteUser()
                } label: {
                    Text("Confirm Account Delete")
                }

            }
        }
        .sheet(isPresented: $isPresented, content: {
            WelcomeViewFlow(mainScreen: screen)
        })
    }
}
