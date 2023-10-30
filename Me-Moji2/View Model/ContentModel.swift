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
    @Published var subtotal : Int = 0
    @Published var isPresented = false
    @Published var isTapped = false
    @Published var addressName = ""
    @Published var FirebasePurchaseDownload = [FirebasePurchase]()
    let publishable_key = "pk_test_51MLoN5Ln6NfP8QkIyweffNkHamevd46IZdUFQundD5CCFD0f7IO0zUu9HjFaQ2GkycyABvxZYKzAGCdroXSr3swp00wey0QPoV"
    
    @Published var HairStyle = ["LongHair1", "ShortHair1", "AnimatedFace"]
    
    private var db = Firestore.firestore()
    
    
    //For Stripe
    @Published var email = ""

  
    

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
    
    //Function to create user in Firebase DB
    func createUser (email: String, password: String, firstName: String, lastName: String) async throws {
        Auth.auth().createUser(withEmail: email, password: password) { Authresults, error in
            //check for errors
            if let err = error {
                self.errorMessage = err.localizedDescription
                self.displayError.toggle()
                
            } else {
                self.userId = Authresults!.user.uid
                
                Task{
                    do {
                        try await self.updateFirebaseUser(firstName: firstName, lastName: lastName)
                        
                    } catch {
                        print("error")
                    }
                }
            }
        }
        
    }
      
    //Sign in Existing User
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
    
    //Upload Succesful purchase to firebase
    func uploadPurchaseSuccess(address: address, amount: Int) {
        var firebaseUpload : FirebasePurchase = FirebasePurchase(date: Date(), address: address, Products: self.purchased, amount: amount)

        do {
            try db.collection("stripe_customers").document(Auth.auth().currentUser?.uid ?? "").collection("purchased_success").addDocument(from: firebaseUpload) { error in
                print(error?.localizedDescription)
                
            }
            self.purchased.removeAll()
        }
        catch {
                
        }   
    }
    
    //Downloads purchase history from firebase
    func downloadPurchaseHistory() async throws {
        
        db.collection("stripe_customers").document(Auth.auth().currentUser?.uid ?? "").collection("purchased_success").addSnapshotListener({ snapshot, error in
            if error == nil {
                guard let document = snapshot?.documents else {
                    return
                }
                     self.FirebasePurchaseDownload =  document.compactMap {  (queryDocumentSnapshot)-> FirebasePurchase? in
                         
                         return try?   queryDocumentSnapshot.data(as: FirebasePurchase.self)
                    }
                        
                }
                    
                })
                    
    }

    func updateFirebaseUser(firstName: String, lastName: String) async throws {
        //Update firebase profile Name
       
            let listener = db.collection("stripe_customers").document(self.userId)
                .addSnapshotListener { snapshot, error in
                    guard let document = snapshot else {
                        print("Error fetching document: \(error!)")
                        
                        return
                    }
                    guard let data = document.data() else {
                        print("Document data was empty.")
                        
                        return
                    }
                    //   print("Current data: \(data)")
                    self.db.collection("stripe_customers").document(self.userId).updateData(["FirstName":firstName,
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
                                     //   self.isPresented = true
                                    }
                                    
                                }
                            }
                }
        //    listener.remove()
        
        
       
        
    }
    
    func SignOut() {
        
        do {
            let signOut = try Auth.auth().signOut()
            print(Auth.auth().currentUser)
            
        } catch {
            print("Error")
        }
    }
    
    //MARK: Need to delete from Stripe as well
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
    
    //Called to dismiss Checkout View Sheet
    func dismissSheet() {
        self.isPresented.toggle()
    }
    
    func emptyString(checkString : String) -> Bool {
        if checkString.isEmpty == true {
            return true
        } else {
            return false
        }
    }
    
    //MARK: NOt sure? Do i need?
    func listenToAuthState() {
        Auth.auth().addStateDidChangeListener { [weak self] _, user in
            guard let self = self else {
                return
            }
            self.user = user
        }
    }
    
    
}





