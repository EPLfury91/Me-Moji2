//
//  NewAccountView.swift
//  Me-Moji2
//
//  Created by Brett Tracey on 12/4/22.
//

import SwiftUI
import FirebaseAuth
import Firebase
import FirebaseFunctions
import FirebaseFirestore

struct NewAccountView: View {
    @EnvironmentObject var model: ContentModel
    @State var firstName = ""
    @State var lastName = ""
    @State var userName = ""
    @State var email = ""
    @State var password = ""
    @State var popover = false
    @State var disabled = false
    @Binding var currentScreen : Screen
        
    
    var body: some View {
        VStack(spacing: 1){
             
            textOutlineView(inputValue: $firstName, displayValue: "First Name")
            textOutlineView(inputValue: $lastName, displayValue: "Last Name")
            textOutlineView(inputValue: $email, displayValue: "Email")
            textOutlineView(inputValue: $password, displayValue: "Password")
            
            Spacer(minLength: 5.0)
            
            Button(action: {
                    model.createUser(email: email, password: password, firstName: firstName, lastName: lastName)
                if Auth.auth().currentUser != nil {
                    currentScreen = .Customize
                }
                    
                }, label: {
                    buttonDisplay(buttonLabel: "Create Account", isDisabled: model.emptyString(checkString: firstName) || model.emptyString(checkString: lastName) || model.emptyString(checkString: email) || model.emptyString(checkString: password) )
            })
            .disabled(model.emptyString(checkString: firstName) || model.emptyString(checkString: lastName) || model.emptyString(checkString: email) || model.emptyString(checkString: password))
            
            
            .alert("Error", isPresented: $model.displayError) {
                    //Add Buttons here
                } message: {
                    Text(model.errorMessage)
                }
            
        }
        .padding(.vertical)
    }
    
}

//struct NewAccountView_Previews: PreviewProvider {
//    static var previews: some View {
//        NewAccountView()
//    }
//}
