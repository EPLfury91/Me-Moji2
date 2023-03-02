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
    
    var body: some View {
        VStack(spacing: 1){
            textOutlineView(inputValue: $firstName, displayValue: "First Name")
            textOutlineView(inputValue: $lastName, displayValue: "Last Name")
            textOutlineView(inputValue: $email, displayValue: "Email")
            textOutlineView(inputValue: $password, displayValue: "Password")
            
           
            Spacer(minLength: 5.0)
            
            Button(action: {
                
                //MARK: TO DO: Error check
                Auth.auth().createUser(withEmail: email, password: password) { Authresults, error in
                    
                    //check for errors
                    if let err = error {
                        Text("Error creating new user")
                    } else {
                        let db = Firestore.firestore()
                        
                        db.collection("Users").addDocument(data: ["FirstName":firstName,"LastName":lastName, "UUID": Authresults!.user.uid]){ error in
                            if error != nil {
                                Text("Error creating user")
                            }
                            
                        }
                        model.isLoggedIn = true
                        
//                        Functions.functions().httpsCallable("createStripeCustomer").call(completion: <#T##(HTTPSCallableResult?, Error?) -> Void#>)
                        
                        
                    }
                    
                }
            }, label: {
                buttonDisplay(buttonLabel: "Create Account")
            })
            
            //TO DO: Able to sign in w FB?
            
        }
        .padding(.vertical)
    }
    
}

struct NewAccountView_Previews: PreviewProvider {
    static var previews: some View {
        NewAccountView()
    }
}
