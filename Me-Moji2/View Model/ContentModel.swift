//
//  ContentModel.swift
//  Me-Moji2
//
//  Created by Brett Tracey on 12/4/22.
//

import Foundation
import Firebase
import SwiftUI
import StripePaymentSheet
import Stripe
import FirebaseAuth
import FirebaseFirestore
import FirebaseFunctions
//import FBSDKLoginKit
//import FBSDKCoreKit



import FirebaseCore
import UIKit


class ContentModel: ObservableObject {
    @Published var isLoggedIn = false
    @Published var item = [CustomizeItem]()
    @Published var purchased = [Purchased]()
    @Published var avatar = [Avatar]()
    @Published var userId = ""
    @Published var list : FirebaseItem = FirebaseItem(FirstName: "", HairStyle: "", LastName: "")
    @Published var errorMessage = ""
    @Published var displayError = false
    @Published var firstName = ""
    @Published var lastName = ""
    let publishable_key = "pk_test_51MLoN5Ln6NfP8QkIyweffNkHamevd46IZdUFQundD5CCFD0f7IO0zUu9HjFaQ2GkycyABvxZYKzAGCdroXSr3swp00wey0QPoV"
    
    //For Stripe
    @Published var email = ""
    //@State var user : User
    
    private var db = Firestore.firestore()
    
    
    @Published var HairStyle = ["LongHair1", "ShortHair1", "AnimatedFace"]
    
    
    init(){
        getRemoteData()
        avatar.append(Avatar(headShape: "Face1", hairStyle: ""))
    }
    
    //Retrieve remote data from Github
    func getRemoteData() {
        
        //Need to get string for json
        let urlString = "https://eplfury91.github.io/learningApp-Data/data.json"
        let url = URL(string: urlString)
        
        guard url != nil else {
            
            //couldnt find site
            return
        }
        
        //create url request
        let request = URLRequest(url: url!)
        
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            //check if there is an error
            
            guard error == nil else {
                return
            }
            
            do {
                //create json decoder
                let decoder = JSONDecoder()
                
                let item = try decoder.decode([CustomizeItem].self, from: data!)
                
                DispatchQueue.main.async {
                    self.item += item
                }
            }
            catch {
                error
            }
        }
        //kick off data task
        dataTask.resume()
    }
    
    
    //Functions for Purchase
    func getSubTotal()-> Int{
        var subtotal = 0
        
        for index in 0..<purchased.count {
            subtotal += purchased[index].item.card.price
        }
        
        return subtotal
    }
    
    func deleteItem(index: Int){
        purchased.remove(at: index)
    }
    
    
    
    
    func assignUserObject () {
        let db = Firestore.firestore()
        
        db.collection("Users").document(self.userId).setData(["FirstName":firstName,"LastName":lastName]){ error in
            if error != nil {
                self.errorMessage = error!.localizedDescription
                self.displayError.toggle()
            } else {
                
                
            }
        }
    }
    
    
    
    
    //MARK: Firebase Login
    var user: User? {
        didSet {
            objectWillChange.send()
        }
    }
    
    func listenToAuthState() {
        Auth.auth().addStateDidChangeListener { [weak self] _, user in
            guard let self = self else {
                return
            }
            self.user = user
        }
    }
    
    
    
    func createUser (email: String, password: String, firstName: String, lastName: String) {
        Auth.auth().createUser(withEmail: email, password: password) { Authresults, error in
            
            //check for errors
            if let err = error {
                self.errorMessage = err.localizedDescription
                self.displayError.toggle()
                
            } else {
                let db = Firestore.firestore()
                
                self.userId = Authresults!.user.uid
                
                self.createStripeCustomer()
                
                //Update firebase profile Name
                db.collection("Users").document(self.userId).setData(["FirstName":firstName,"LastName":lastName]){ error in
                    if error != nil {
                        self.errorMessage = error!.localizedDescription
                        self.displayError.toggle()
                    } else {
                        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                        changeRequest?.displayName = firstName
                        changeRequest?.commitChanges { error in
                            //Handle error
                            if let err = error {
                                print(error?.localizedDescription)
                            }
                            
                        }
                        
                    }
                }
            }
            
        }
    }
    
    func SignIn (email: String, password: String, error: String) {
        
        //Autheticate and Login
        Auth.auth().signIn(withEmail: email, password: password) { authresult, error in
            
            //Handle error
            if let authResult = authresult {
                
                self.userId = authResult.user.uid
                self.fetchData()
                
            } else {
                
                //Handle bad log in
                self.errorMessage = error!.localizedDescription
                self.displayError.toggle()
                
            }
        }
    }
    
    func SignOut() {
        
        do {
            let signOut = try Auth.auth().signOut()
            print(Auth.auth().currentUser)
            
        } catch {
            print("Error")
        }
    }
    
    func deleteUser() {
        
        let user = Auth.auth().currentUser
        guard user != nil else {
            return
        }
        
        
        db.collection("Users").document(user!.uid).delete { error in
            
            if let error = error {
                //Show error message
                print(error.localizedDescription)
            } else {
                user!.delete { error in
                    if let error = error {
                        print(error.localizedDescription)
                    } else {
                        // Account deleted.
                        print("Account Succesfully Deleted!")
                        
                    }
                }
            }
            
        }
        
    }
    
    
    
    func fetchData() {
        
        db.collection("Users").document(self.userId).getDocument { snapshot, error in
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
                        
                        self.avatar[0].hairStyle = self.list.HairStyle
                        
                    }
                    
                    
                } else {
                    //To DO: Handle Error
                }
            }
            
        }
        
    }
    
    
  
    
    
    func updateUserInfo() {
        let user = Auth.auth().currentUser
        if let user = user {
            // The user's ID, unique to the Firebase project.
            // Do NOT use this value to authenticate with your backend server,
            // if you have one. Use getTokenWithCompletion:completion: instead.
            let uid = user.uid
            let email = user.email
            let firstName = user.displayName
            
            //          var multiFactorString = "MultiFactor: "
            //          for info in user.multiFactor.enrolledFactors {
            //            multiFactorString += info.displayName ?? "[DispayName]"
            //            multiFactorString += " "
            //          }
        }
    }
    
    
    func emptyString(checkString : String) -> Bool {
        if checkString.isEmpty == true {
            return true
        } else {
            return false
        }
    }
    
    //MARK: Stripe functions

    func createStripeCustomer () {
        
        let functions = Functions.functions()
        
        functions.useEmulator(withHost: "192.168.1.8", port: 5001)
       
        functions.httpsCallable("createStripeCustomer").call(["full_name" : firstName, "email" : email]) { (response, error) in
            if let error = error {
                print(error)
            }
            if let response = (response?.data as? [String: Any]) {
                let customer_id = response["customer_id"] as! String?
                  print(customer_id)
                //  print(publishable_key)
                Stripe.setDefaultPublishableKey(self.publishable_key)
                //     profile.stripe_customer_id = customer_id!
                let defaults = UserDefaults.standard
                //    currentProfile = profile
                do {
                    //                                try self.db.collection("stripe_customers").document(emailAdd).setData(from: profile)
                    //                                DispatchQueue.main.async {
                    //                                    self.switchToWelcomePage()
                    //                                }
                } catch let error {
                    print (error)
                }
            }
        }
    }
    

    
    
    
}








public protocol AddressViewControllerDelegate: AnyObject {
    /// Called when the customer finishes entering their address or cancels. Your implemententation should dismiss the view controller.
    /// - Parameter address: A valid address or nil if the customer cancels the flow.
    func addressViewControllerDidFinish(_ addressViewController: AddressViewController, with address: AddressViewController.AddressDetails?)
}

class dataServices {
    //STRIPE functions
    
    let BackendUrl = "https://us-east1-me-moji2.cloudfunctions.net/"
    func checkout() {
        
        //create payment intent
        let url = URL(string: BackendUrl + "create-payment-intent")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: {(data, response, error) in
            guard let response = response as? HTTPURLResponse,
                        response.statusCode == 200,
                        let data = data,
                        let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any],
                        let clientSecret = json["clientSecret"] as? String,
                        let publishableKey = json["publishableKey"] as? String else {
                            let message = error?.localizedDescription ?? "Failed to decode response from server."
                          //  self?.displayAlert(title: "Error loading page", message: message)
                            return
                    }
            print("Created PaymentIntent")
    // self?.paymentIntentClientSecret = clientSecret
                   // Configure the SDK with your Stripe publishable key so that it can make requests to the Stripe API
                   // For added security, our sample app gets the publishable key from the server
                   Stripe.setDefaultPublishableKey(publishableKey)
               })
               task.resume()
        
    }
}



