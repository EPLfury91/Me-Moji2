//
//  ForgotPasword.swift
//  Me-Moji2
//
//  Created by Brett Tracey on 12/3/22.
//

import SwiftUI


struct ForgotPasword: View {
    @State var email = ""
    var body: some View {
        VStack{
            
            Text("Enter email here. If we have an associated email address on file, you will receive a link to reset your password")
            
            textOutlineView(inputValue: $email, displayValue: "Enter Email")
            
            Button(action: {
                //TO DO: Send out email
                
                
            }, label: {
                buttonDisplay(buttonLabel: "Submit")
            })
            
        }
    }
}

struct ForgotPasword_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPasword()
    }
}
