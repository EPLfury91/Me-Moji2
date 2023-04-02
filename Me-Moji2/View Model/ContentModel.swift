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
    @Published var list : FirebaseItem = FirebaseItem(FirstName: "", HairStyle: "", LastName: "")
    @Published var errorMessage = ""
    @Published var displayError = false
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
    
    
    //MARK: TO DO: Error check
    func createUser (email: String, password: String, firstName: String, lastName: String) {
        Auth.auth().createUser(withEmail: email, password: password) { Authresults, error in
            
            //check for errors
            if let err = error {
                self.errorMessage = err.localizedDescription
                self.displayError.toggle()
                
            } else {
                let db = Firestore.firestore()
                
                self.userId = Authresults!.user.uid
                
                db.collection("Users").document(self.userId).setData(["FirstName":firstName,"LastName":lastName]){ error in
                
                     if error != nil {
                        self.errorMessage = error!.localizedDescription
                         self.displayError.toggle()
                        
                    }
                    
                }
                self.isLoggedIn = true
                
            }
            
        }
    }
    
    func SignIn (email: String, password: String, error: String) {
        //TO DO: Authenticate and Login
        Auth.auth().signIn(withEmail: email, password: password) { authresult, error in
            //Handle error
            if let authResult = authresult {
                
                self.userId = authResult.user.uid
                self.fetchData()
               
                
                self.isLoggedIn = true
                
            } else {
                
                //Handle bad log in
                self.errorMessage = error!.localizedDescription
                self.displayError.toggle()
               
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
    
    func emptyString(checkString : String) -> Bool {
        if checkString.isEmpty == true {
            return true
        } else {
            return false
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





