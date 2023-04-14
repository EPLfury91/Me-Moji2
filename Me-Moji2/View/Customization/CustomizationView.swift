//
//  CustomizationView.swift
//  Me-Moji2
//
//  Created by Brett Tracey on 11/28/22.
//

import SwiftUI
import FirebaseFirestore
import FBSDKLoginKit


struct CustomizationView: View {
    @State var selection = 0
    @State var isSelected = true
    let db = Firestore.firestore()
    @EnvironmentObject var model : ContentModel

    var body: some View {
 //       Spacer()
        VStack(alignment: .leading){
            HStack{
                Button(action: {
                    db.collection("Users").document(model.userId).updateData(["HairStyle" : model.avatar[0].hairStyle])
                }, label: {
                    Text("Save")
                })
                
                Spacer()
                
                
                Spacer()
                
                NavigationLink(destination: CardChoice(), label: {
                    Text("Next")
                })
            }
            
            FaceDisplayView()
                .background(Color.blue)
            
            Spacer()
            
            ZStack(alignment: .bottom){
               
                    ItemDisplayView()
                    .frame(width: UIScreen.main.bounds.width / 1.1, height: UIScreen.main.bounds.height / 8)
                        .offset(y: selection == 0 ? -80: 300)
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
    

struct CustomizationView_Previews: PreviewProvider {
    static var previews: some View {
        CustomizationView()
    }
}
