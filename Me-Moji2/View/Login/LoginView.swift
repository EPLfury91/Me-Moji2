//
//  LoginView.swift
//  Me-Moji2
//
//  Created by Brett Tracey on 12/2/22.
//

import SwiftUI
import FirebaseAuth
import FirebaseFunctions
import FBSDKLoginKit

struct LoginView: View {
    @EnvironmentObject var model: ContentModel
    @State var userName = ""
    @State var email = ""
    @State var password = ""
    @State var forgotPW = false
    @State var newUser = false
    @Binding var currentScreen : Screen
    @State var TF = 0
  
    
    var body: some View {
        VStack(spacing: 10){
            
            Text("Me-Moji")
                .font(.largeTitle)
                .bold()
            
            VStack(spacing: 1){
                textOutlineView(inputValue: $email, displayValue: "Username")
                
                SecureOutlineView(inputValue: $password, displayValue: "Password")
            }
            
            //Forgot Password Button
            Button(action: {
                self.forgotPW = true
            }, label: {
                Text("Forgot Password")
            })
            .sheet(isPresented: $forgotPW, content: {
                ForgotPasword()
            })
             
            //Log in Button
            Button(action: {
                model.SignIn(email: email, password: password, error: "")
                if Auth.auth().currentUser != nil {
                    currentScreen = .MainbodyView
                }
         
            }, label: {
                buttonDisplay(buttonLabel: "Login")
            })
            .alert("Error", isPresented: $model.displayError) {
                //Add Buttons here
            } message: {
                Text(model.errorMessage)
            }
            
            //FB Log in
            FBView(TF: $currentScreen)
            
            //New Account Button
            HStack{
                Text("New to Me-Moji?")
                
                Button(action: {
                    self.newUser = true
                }, label: {
                    Text("Sign Up")
                })
                .sheet(isPresented: $newUser, content: {
                    NewAccountView(currentScreen: $currentScreen)
                })
            }
        }
    }
}

