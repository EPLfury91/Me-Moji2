//
//  NewAccountView.swift
//  Me-Moji2
//
//  Created by Brett Tracey on 12/4/22.
//

import SwiftUI

struct NewAccountView: View {
    @State var firstName = ""
    @State var lastName = ""
    @State var userName = ""
    @State var password = ""
    
    var body: some View {
        VStack(spacing: 1){
            textOutlineView(inputValue: firstName, displayValue: "First Name")
            textOutlineView(inputValue: lastName, displayValue: "Last Name")
            textOutlineView(inputValue: userName, displayValue: "Username")
            textOutlineView(inputValue: password, displayValue: "Password")
            
            Spacer(minLength: 5.0)
            
            Button(action: {
                
            }, label: {
                buttonDisplay(buttonLabel: "Create Account")
            })
            
        }
    }
}

struct NewAccountView_Previews: PreviewProvider {
    static var previews: some View {
        NewAccountView()
    }
}
