//
//  LoginView.swift
//  Me-Moji2
//
//  Created by Brett Tracey on 12/2/22.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var model: ContentModel
    @State  var userName = ""
    @State  var password = ""
    @State var forgotPW = false
    @State var newUser = false
    
    var body: some View {
        VStack(spacing: 10){
            
            Text("Me-Moji")
                .font(.largeTitle)
                .bold()
            
            VStack(spacing: 1){
                textOutlineView(inputValue: userName, displayValue: "Username")
                
                SecureOutlineView(inputValue: password, displayValue: "Password")
    
            }

            
            
            //Forgot Password
            Button(action: {
                self.forgotPW = true
            }, label: {
                Text("Forgot Password")
            })
            .sheet(isPresented: $forgotPW, content: {
               ForgotPasword()
            })
            
            Button(action: {
                //Login
                model.isLoggedIn = true
                
            }, label: {
                buttonDisplay(buttonLabel: "Login")
            })
            
            HStack{
                Text("New to Me-Moji?")
                
                Button(action: {
                    self.newUser = true
                }, label: {
                   Text("Sign Up")
                })
                .sheet(isPresented: $newUser, content: {
                    NewAccountView()
                })
            }
            
                
        }
    }
}

