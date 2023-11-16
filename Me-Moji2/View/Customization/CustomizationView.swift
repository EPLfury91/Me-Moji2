//
//  CustomizationView.swift
//  Me-Moji2
//
//  Created by Brett Tracey on 11/28/22.
//

import SwiftUI
import FirebaseFirestore
import FBSDKLoginKit
import FirebaseAuth


struct CustomizationView: View {
    @EnvironmentObject var model : ContentModel
    @State var selection = 0
    @State var isSelected = true
    @Binding var currentScreen : MainScreen
    
    let db = Firestore.firestore()
    
    var body: some View {
        VStack(alignment: .center, spacing: 0){
            
            //Header
            HStack{
                
                //Save Button
                Button(action: {
                    db.collection("stripe_customers").document(AuthViewModel.currentUser()).updateData(["HairStyle" : model.avatar[0].face.hairStyle])
                }, label: {
                    Text("Save")
                })
                
                Spacer()
                
                //Move to Next Screen Button
                Button {
                    currentScreen = .CardChoices
                } label: {
                    Text("Next")
                }
            }
            
            //Main Face View
            
            FaceDisplayView()
                .background(Color.blue)
                .frame(alignment: .center)
            
            Spacer()
            
            
            //Moving Screen w customization pieces
            ZStack(alignment: .bottom){
               
                    ItemDisplayView()
                    .frame(width: UIScreen.main.bounds.width / 1.1, height: UIScreen.main.bounds.height / 8)
                        .offset(y: selection == 0 ? -72: 300)
                        .animation(.spring(response: 0.55, dampingFraction: 1, blendDuration: 0.5))
                        .foregroundColor(.gray)
               
                   /* Rectangle()
                        .frame(width: UIScreen.main.bounds.width / 1.1, height: UIScreen.main.bounds.height / 10)
                        .foregroundColor(.white)
                     */
                    Picker("", selection: $selection){
                        Text("Body Type")
                            .tag(0)
                        Text("Face")
                            .tag(1)
                        Text("Clothes")
                            .tag(2)
                        Text("Quick")
                            .tag(3)
                    }
                    .pickerStyle(.segmented)
               
            }
            //.frame(alignment: .bottom)
           
        }
        .ignoresSafeArea()
    }
        
}
    
