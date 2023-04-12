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



class MyViewController: UIViewController, LoginButtonDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
            if let token = AccessToken.current, !token.isExpired {
                // User is logged in, do work such as go to next view controller.
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
            
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        
    }
}


struct MyView: UIViewControllerRepresentable {
    typealias UIViewControllerType = MyViewController
    
    func makeUIViewController(context: Context) -> MyViewController {
        let facebook = MyViewController()
        
        return facebook
    }
    
    func updateUIViewController(_ UIViewController: MyViewController, context: Context) {
        
    }
    
    
}

