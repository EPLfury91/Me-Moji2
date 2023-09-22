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
    @Published var subtotal = 0
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
    func getSubTotal() {
        
        self.subtotal = 0
        
        for index in 0..<purchased.count {
            self.subtotal += purchased[index].item.card.price
        }
        
    }
    
    func deleteItem(index: Int){
        purchased.remove(at: index)
    }
    

    func assignUserObject () {
        let db = Firestore.firestore()

        db.collection("stripe_customers").document(self.userId).setData(["FirstName":firstName,"LastName":lastName]){ error in
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
    
    
    //Function to create user in Firebase DB
    
    func createUser (email: String, password: String, firstName: String, lastName: String) {
        Auth.auth().createUser(withEmail: email, password: password) { Authresults, error in
            //check for errors
            if let err = error {
                self.errorMessage = err.localizedDescription
                self.displayError.toggle()
                
            } else {
                let db = Firestore.firestore()
                
                self.userId = Authresults!.user.uid
                
                
                //Update firebase profile Name
                db.collection("stripe_customers").document(self.userId).updateData([  "FirstName":firstName,
                                                                        "LastName":lastName,
                                                                        "HairStyle": ""]){ error in
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
        
        
        db.collection("stripe_customers").document(user!.uid).delete { error in
            
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
        
        db.collection("stripe_customers").document(self.userId).getDocument { snapshot, error in
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
    
    //MARK: Stripe functions
    
    
    //MARK: This function isn't needed, apparently works without it
    //This function is used and appears to be working correctly
    func createStripeCustomer () {
        
        let functions = Functions.functions()
        
        
        functions.useEmulator(withHost: "192.168.1.8", port: 5001)
      //  functions.useEmulator(withHost: "127.0.0.1", port: 5001)
        //IP Address
     //   functions.useEmulator(withHost: "192.168.1.9", port: 5001)
        


        
        functions.httpsCallable("createStripeCustomer").call(["full_name" : firstName, "email" : email]) { results, error in
            if let error = error {
                print(error)
            } else {
                if let results = (results?.data as? [String: Any]) {
                    let customer_id = results["customer_id"] as! String?
                      print(customer_id)
                    print("HELLLO THEre")
                    //  print(publishable_key)
                   
                    Stripe.setDefaultPublishableKey(self.publishable_key)
                    //     profile.stripe_customer_id = customer_id!
                    let defaults = UserDefaults.standard
                    //    currentProfile = profile
                    do {
    //                    try self.db.collection("stripe_customers").document(emailAdd).setData(from: profile)
    //                    DispatchQueue.main.async {
    //                        self.switchToWelcomePage()
    //                    }
                    } catch let error {
                        print (error)
                    }
                }
            }
            
          
        }
    }
    
    
    
    
    
    
    
}





