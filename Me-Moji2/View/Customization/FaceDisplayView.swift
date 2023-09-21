//
//  FaceDisplayView.swift
//  Me-Moji2
//
//  Created by Brett Tracey on 11/28/22.
//

import SwiftUI

struct FaceDisplayView: View {
    
    @EnvironmentObject var model : ContentModel
    
    //MARK: Need to get rid of hard coded numbers for frame size
    var body: some View {
        ZStack(alignment: .center){
            
            Image(model.avatar[0].hairStyle)
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200, alignment: .center)
                .offset(y: -75)
               
            
            Image("Face1")
                .resizable()
                .scaledToFit()
                .frame(width: 250, height: 300, alignment: .center)
            
        }
        
    }   
}
    
