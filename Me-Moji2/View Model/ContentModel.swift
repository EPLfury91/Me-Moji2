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
    @Published var currentItem : CustomizeItem?
    @Published var displayArray = [CustomizeItem]()
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
    @Published var CartTapped = false
    @Published var addressName = ""
    @Published var firebaseItem : FirebasePurchase = .init(date: Date(), address: address(name: "", line1: "", line2: "", postal_code: "", state: "", city: ""), Products: [Purchased(id: 0, quantity: 0, item: Me_Moji(avatar: Avatar(headShape: "", face: Face(hairStyle: "", eyeBrow: "")), card: CustomizeItem(id: 0, name: "", category: "", image: "", price: 0, hairPlacex: 0, hairPlacey: 0, eyePlacex: 0, eyePlacey: 0, caption: "")))], amount: 0)
    @Published var FirebasePurchaseDownload = [FirebasePurchase]()
    @Published var listener: ListenerRegistration?
    let publishable_key = "pk_test_51MLoN5Ln6NfP8QkIyweffNkHamevd46IZdUFQundD5CCFD0f7IO0zUu9HjFaQ2GkycyABvxZYKzAGCdroXSr3swp00wey0QPoV"
    
    @Published var HairStyle = ["LongHair1", "ShortHair1", "AnimatedFace"]
    @Published var Eyebrow = ["Eyebrow1", "ShortHair1", "AnimatedFace"]
    
    private var db = Firestore.firestore()
    
    
    //For Stripe
    @Published var email = ""

    init(){
        getRemoteData()
        avatar.append(Avatar(headShape: "Face1", face: Face(hairStyle: "", eyeBrow: "")))
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
    
    func createCardArray(selection: String){
        displayArray.removeAll()
        
        
        for index in 0..<self.item.count {
            if item[index].category == selection {
                displayArray.append(item[index])
            }
            
        }
       
    }
    
    
//Functions for Purchase
    func getSubTotal() {
        
        self.subtotal = 0
        
        for index in 0..<purchased.count {
            self.subtotal += purchased[index].item.card.price * purchased[index].quantity
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
        do {
            let Authresults = try await  Auth.auth().createUser(withEmail: email, password: password)
            
            self.userId = Authresults.user.uid
            
            try await db.collection("stripe_customers").document(self.userId).setData( ["FirstName":firstName, "LastName": "vdsjn", "HairStyle":"" ])
            
            Task{
                do {
                    try await self.updateFirebaseUser(firstName: firstName, lastName: lastName)
                  
                   // sleep(3)
                    self.fetchData()
                    self.isPresented = true
                    
                } catch {
                    print(error.localizedDescription)
                }
            }
            
        }catch{
            print(error)
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
        
        db.collection("stripe_customers").document(Auth.auth().currentUser!.uid).getDocument { snapshot, error in
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
                        self.avatar[0].face.hairStyle = self.list.HairStyle
                        
                    }
                    
                } else {
                    //To DO: Handle Error
                }
            }
            
        }
        
    }
    
    //Upload Succesful purchase to firebase
    func uploadPurchaseSuccess(address: address, amount: Int) async throws->DocumentReference {
        var ref: DocumentReference? = nil
        var firebaseUpload : FirebasePurchase = FirebasePurchase(date: Date(), address: address, Products: self.purchased, amount: amount)

        do {

            ref = try await db.collection("stripe_customers").document(Auth.auth().currentUser?.uid ?? "").collection("purchased_success").addDocument(from: firebaseUpload)
                
            
            self.purchased.removeAll()
            self.getSubTotal()
            
        }
        catch {
            print(error.localizedDescription)
        }
        
      return ref!
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
                
                self.FirebasePurchaseDownload.sort(by: { item1, item2 in
                    item1.date > item2.date
                }) 
                        
            }
                    
        })
                    
    }
    
    func downloadOnePurchase(reference: DocumentReference) async throws {
        
        do {
            self.firebaseItem = try await db.collection("stripe_customers").document(Auth.auth().currentUser?.uid ?? "").collection("purchased_success").document(reference.documentID).getDocument().data(as: FirebasePurchase.self)
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    func updatePassword(password: String)async throws->String {
        var returnMessage : String
        do {
            try await Auth.auth().currentUser?.updatePassword(to: password)
            returnMessage = "Password Update Successful"
        } catch{
            returnMessage = error.localizedDescription
        }
        return returnMessage
    }
    
    func updateEmail(email: String) async throws-> String {
        var returnMessage : String
        do {
            try await Auth.auth().currentUser?.updateEmail(to: email)
            returnMessage = "Email Update Successful"
        } catch{
            //print(error.localizedDescription)
            returnMessage = error.localizedDescription
        }
        
        return returnMessage
        
    }
    
    func removeListner(){
        self.listener?.remove()
    }
    
   
    
    func updateFirebaseName2(firstName1: String, lastName1: String) async throws {
       //  var ReturnMessage: String = ""
        do {
           
            try await self.db.collection("stripe_customers").document(self.userId).updateData(["FirstName":firstName1,
                                                                                "LastName":lastName1])
            
            let changeRequest =   Auth.auth().currentUser?.createProfileChangeRequest()
                                       changeRequest?.displayName = firstName1
                                       changeRequest?.commitChanges  { error in
                                           //Handle error
                                           if let err = error {
                                              // ReturnMessage = err.localizedDescription
           
                                           }
                                       }
           
                                       //ReturnMessage = "Account update succesful"
          
           
        } catch{
            print(error)
        }
       
    }

    //Update firebase profile Name
    func updateFirebaseName(firstName: String, lastName: String, displayFirst: String, displayLast: String)async throws  {
        var ReturnMessage: String = ""
        
         guard self.userId != "" else {
             throw ErrorMessage.NoUserId
         }
       
        self.listener = await db.collection("stripe_customers").document(self.userId)
                .addSnapshotListener { snapshot, error in
                    guard let document = snapshot else {
                        let ReturnMessage = String("Error fetching document: \(error!)")
                        
                        return
                    }
                    guard let data = document.data() else {
                        let ReturnMessage = String("Document data was empty.")
                        
                        return
                    }
                    
            }
         
            do {
                
                var lastName1 = lastName
                var firstName1 = firstName
                
                if lastName == "" {
                    lastName1 = displayLast
                }
                if firstName == "" {
                    firstName1 = displayFirst
                }
                    
                
            try await updateFirebaseName2(firstName1: firstName1, lastName1: lastName1)
               
            } catch{
              
            }
        
        
        
    }
    

    func updateFirebaseUser(firstName: String, lastName: String) async throws {
        //Update firebase profile Name
       
        self.listener = db.collection("stripe_customers").document(self.userId)
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
                    
                    Task{
                        do{
                            try await self.db.collection("stripe_customers").document(self.userId).updateData(["FirstName":firstName,
                                                                                                               "LastName":lastName,
                                                                                                               "HairStyle": ""])
                            let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                            changeRequest?.displayName = firstName
                            
                            try await changeRequest?.commitChanges()
                            
                          //  self.isPresented = true
                            
                        }catch{
                            self.errorMessage = error.localizedDescription
                            self.displayError.toggle()
                        }
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
    
    //MARK: Need to delete from Stripe as well
    func deleteUser() async throws->String {
        var returnMessage : String
        let user = Auth.auth().currentUser
        
        guard user != nil else {
            returnMessage = "Error"
            return returnMessage
        }
        do{
            try await user?.delete()
            returnMessage = "Account Succesfully Deleted"
        } catch {
            returnMessage = error.localizedDescription
        }
        return returnMessage
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





