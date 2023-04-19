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


class MyViewController: UIViewController, LoginButtonDelegate{
    @EnvironmentObject var model: ContentModel
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let token = AccessToken.current, !token  .isExpired {
            // User is logged in, do work such as go to next view controller.
            let loginButton = FBLoginButton()
            view.addSubview(loginButton)
            
    
        }
        else {
            let loginButton = FBLoginButton()
            loginButton.center = view.center
            loginButton.delegate = self
            loginButton.permissions = ["public_profile", "email"]
            view.addSubview(loginButton)
        }
        
    }
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        if let error = error {
            print(error.localizedDescription)
            return
        } else {
            let credential = FacebookAuthProvider
                .credential(withAccessToken: AccessToken.current!.tokenString)
            
            Auth.auth().signIn(with: credential) { authResult, error in
                
                //Handle error
                if let Err = error {
                    print(Err.localizedDescription)
                } else {
                    
                    //User is signed in
                    self.model.isLoggedIn = true
                }
            }
        }
        
        
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        try! Auth.auth().signOut()
    }
    
    func updateFirebaseDB () {
        Profile.loadCurrentProfile { profile, error in
            if let firstname = profile?.firstName {
                
            }
        }
    }
}



struct MyView: UIViewControllerRepresentable {
    typealias UIViewControllerType = MyViewController
    @EnvironmentObject var model: ContentModel
    
    func makeUIViewController(context: Context) -> MyViewController {
        let facebook = MyViewController()
        
        return facebook
    }
    
    func updateUIViewController(_ UIViewController: MyViewController, context: Context) {
        if let token = AccessToken.current, !token  .isExpired {
            // User is logged in, do work such as go to next view controller.
         //   self.model.isLoggedIn = true
        }
    }
}


