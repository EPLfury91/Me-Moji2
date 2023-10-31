//
//  ForgotPasword.swift
//  Me-Moji2
//
//  Created by Brett Tracey on 12/3/22.
//

import SwiftUI
import FirebaseAuth


struct ForgotPasword: View {
    @State var email = ""
    @State var displayPopup = false
    @State var message = ""
    @Binding var forgotPW: Bool
    
    
    var body: some View {
        VStack{
            
            Text("Enter email here. If we have an associated email address on file, you will receive a link to reset your password")
            
            textOutlineView(inputValue: $email, displayValue: "Enter Email")
            
            Button(action: {
                //TO DO: Send out email
                Auth.auth().sendPasswordReset(withEmail: email) { error in
                    //check for error, otherwise send email
                    if let error = error {
                        self.message = error.localizedDescription
                    } else {
                        self.message = String("Email Sent")
                    }
                    
                    displayPopup.toggle()
                        
                }
                
            }, label: {
                buttonDisplay(buttonLabel: "Submit")
            })
            
            Button(action: {
                //Dismiss tabview
                forgotPW.toggle()
                
            }, label: {
                buttonDisplay(buttonLabel: "Dismiss")
            })
            
        }
    }
}
