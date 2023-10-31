//
//  ProfileUpdateView.swift
//  Me-Moji2
//
//  Created by Brett Tracey on 10/31/23.
//

import SwiftUI
import Firebase

struct ProfileUpdateView: View {
    @EnvironmentObject var model: ContentModel
    var user = Auth.auth().currentUser
    var body: some View {
        List{
            NavigationLink {
                updateView(displayValue: user!.displayName!)
            } label: {
                ListView(title: "Name", currentValue: user!.displayName!)
            }
            NavigationLink {
                updateView(displayValue: user!.email!)
            } label: {
                ListView(title: "Email", currentValue: user!.email!)
            }

            NavigationLink {
                updateView(displayValue: user!.displayName!)
            } label: {
                ListView(title: "Password", currentValue: user!.displayName!)
            }
        }
    }
}


struct ListView: View {
    @State var title: String
    @State var currentValue: String
    var body: some View {
        VStack(alignment: .leading){
            Text(title)
                .fontWeight(.bold)
                .foregroundStyle(Color.white)
            Text(currentValue)
                .fontWeight(.medium)
                .foregroundStyle(Color.gray)
        }
    }
}

struct updateView: View {
    @State var change: String = ""
    var displayValue: String
    
    var body: some View{
        VStack{
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(lineWidth: 2)
                    .frame(width: UIScreen.main.bounds.width - 20, height: 50, alignment: .center)
                    .foregroundColor(.blue)
                
                TextField(text: $change, prompt: Text("\(displayValue)")) {
                    Text("\(displayValue)")
                        .foregroundColor(.primary)
                }
            }
            
            
            Button {
                //Call function to update firebase/Stripe
                model.updateFirebaseUser(firstName: <#T##String#>, lastName: <#T##String#>)
            } label: {
                buttonDisplay(buttonLabel: "Update", isDisabled: false)
            }

        }
    }
}
