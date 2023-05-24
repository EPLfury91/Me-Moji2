//
//  FacebookModel.swift
//  Me-Moji2
//
//  Created by Brett Tracey on 4/9/23.
//


//import FBSDKLoginKit
import FBSDKCoreKit
import UIKit
import SwiftUI
import FBSDKLoginKit
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore



//MARK: FacebookLogin


struct FBView: View {
    @ObservedObject var fbmanager = UserLoginManager()
    @Binding var TF : Screen
    
    var body: some View {
        Button {
           
            fbmanager.facebookLogin()
            if Auth.auth().currentUser != nil {
                TF = .Customize
            }
          
        } label: {
            Text("Login with Facebook")
        }
    }
}


class UserLoginManager: ObservableObject {
    @State var CurrentUser = Auth.auth().currentUser ?? nil
    let loginManager = LoginManager()
    
    func facebookLogin() {
        loginManager.logIn(permissions: ["public_profile", "email"], from: MyViewController2()) { results, error in
            if let error = error {
                print(error.localizedDescription)
                return
            } else {
                let credential = FacebookAuthProvider
                    .credential(withAccessToken: AccessToken.current!.tokenString)
                
                let token = results?.token?.tokenString
                
                Auth.auth().signIn(with: credential) { authResult, error in
                    
                    //Handle error
                    if let Err = error {
                        print(Err.localizedDescription)
                    } else {
                        let request = FBSDKLoginKit.GraphRequest(graphPath: "me",
                                                                 parameters: ["fields": "email, name"],
                                                                 tokenString: token,
                                                                 version: nil,
                                                                 httpMethod: .get)
                        
                        request.start(completionHandler: {connection, result, error in
                            self.CurrentUser = Auth.auth().currentUser
                            print("\(result)")
                        })
                        
                    }
                }
            }
            
        }
    }
}




class MyViewController2: UIViewController {
}
