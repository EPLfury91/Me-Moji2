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

class ContentModel: ObservableObject {
    @Published var isLoggedIn = false
    @Published var item = [CustomizeItem]()
    @Published var purchased = [Purchased]()
    @Published var avatar = [Avatar]()
    @Published var userId = ""
    
    
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
    
    
    //MARK: TO DO: Error check
    func createUser (email: String, password: String, firstName: String, lastName: String) {
        Auth.auth().createUser(withEmail: email, password: password) { Authresults, error in
            
            //check for errors
            if let err = error {
                Text("Error creating new user")
            } else {
                let db = Firestore.firestore()
                
                self.userId = Authresults!.user.uid
                
                db.collection("Users").addDocument(data: ["FirstName":firstName,"LastName":lastName, "UUID": Authresults!.user.uid]){ error in
                    if error != nil {
                        Text("Error creating user")
                    }
                    
                }
                self.isLoggedIn = true
                
            }
            
        }
    }
    
    func SignIn (email: String, password: String) {
        //TO DO: Authenticate and Login
        Auth.auth().signIn(withEmail: email, password: password){ authresult, error in
            //Handle error
            if let authResult = authresult {
                self.isLoggedIn = true
                self.userId = authResult.user.uid
            } else {
                
                
                //TO DO: Handle bad log in
                Text("Forgot Password?")
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





