//
//  FacebookModel.swift
//  Me-Moji2
//
//  Created by Brett Tracey on 4/9/23.
//

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
                TF = .MainbodyView
            }
          
        } label: {
            Text("Login with Facebook")
        }
    }
}


class UserLoginManager: ObservableObject {
    @State var CurrentUser = Auth.auth().currentUser ?? nil
    @Published var list : FirebaseItem = FirebaseItem(FirstName: "", HairStyle: "", LastName: "")
    let loginManager = LoginManager()
    let db = Firestore.firestore()
    @Published var user : User2 = User2(FirstName: "", LastName: "")

    
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
                        
                        //Account created succesfully
                        let request = FBSDKLoginKit.GraphRequest(graphPath: "me",
                                                                 parameters: ["fields": "email, name"],
                                                                 tokenString: token,
                                                                 version: nil,
                                                                 httpMethod: .get)
                        
                        request.start(completionHandler: {connection, result, error in
                            self.CurrentUser = Auth.auth().currentUser
                            
                            
                            print("\(result)")
                        })
                        
                        
                        Profile.loadCurrentProfile { profile, error in
                            if let firstName = profile?.firstName {
                                
                                //update Firebase user withu FirstName
                                let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                                changeRequest?.displayName = firstName
                                changeRequest?.commitChanges { error in
                                    //Handle error
                                    if let err = error {
                                        print(error?.localizedDescription)
                                    }
                                   
                                }
                                
                                
                                self.db.collection("Users").document(Auth.auth().currentUser!.uid).setData(["FirstName":profile?.firstName,"LastName":profile?.lastName]){ error in
                                
                                     if error != nil {
                                        print(error!.localizedDescription)
                                        
                                    }
                                }
                            }
                        }
                        
                    }
                }
            }
            
        }
    }
    
    func fetchData() {
        
        db.collection("Users").document(Auth.auth().currentUser!.uid).getDocument { snapshot, error in
            //check for errors
            if error == nil {
                if let snapshot = snapshot  {
                    
                    DispatchQueue.main.async {
                        //Get all collections
                        
                        self.list = snapshot.data().map { d in

                            return FirebaseItem(
                                                FirstName: d["FirstName"] as? String ?? "",
                                                HairStyle: d["HairStyle"] as? String ?? "",
                                                LastName: d["LastName"] as? String ?? "")
                        }!
                        
                    }
                        
                    
                } else {
                    //To DO: Handle Error
                }
            }
            
        }
             
    }
}




class MyViewController2: UIViewController {
}
