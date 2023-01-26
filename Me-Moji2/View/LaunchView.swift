//
//  ContentView.swift
//  Me-Moji2
//
//  Created by Brett Tracey on 11/28/22.
//

import SwiftUI

struct LaunchView: View {
    @EnvironmentObject var model: ContentModel
    
   /* let STRIPE_PUBLISHABLE_KEY = "<pk_test_51MLoN5Ln6NfP8QkIyweffNkHamevd46IZdUFQundD5CCFD0f7IO0zUu9HjFaQ2GkycyABvxZYKzAGCdroXSr3swp00wey0QPoV>"*/
    
    
    var body: some View {
        NavigationView{
            VStack {
                
                //MARK: Need to remove reference
                if model.isLoggedIn == false {
                    LoginView()
                } else {
                    CustomizationView()
                }
                
            }
            .padding()
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView()
    }
}
