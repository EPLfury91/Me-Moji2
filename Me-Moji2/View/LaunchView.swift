//
//  ContentView.swift
//  Me-Moji2
//
//  Created by Brett Tracey on 11/28/22.
//

import SwiftUI
import FBSDKLoginKit
import FBSDKCoreKit

struct LaunchView: View {
    @EnvironmentObject var model: ContentModel

    var body: some View {
        NavigationView{
            VStack {
                //MARK: Need to remove reference
                
                if let token = AccessToken.current, !token  .isExpired {
                    CustomizationView()
                } else if model.isLoggedIn == false {
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
