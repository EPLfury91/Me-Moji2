//
//  FaceDisplayView.swift
//  Me-Moji2
//
//  Created by Brett Tracey on 11/28/22.
//

import SwiftUI

struct FaceDisplayView: View {
    var body: some View {
        ZStack{
            
            Image("LongHair1")
                .resizable()
                .scaledToFit()
            Image("Face1")
                .resizable()
                .scaledToFit()
            
        }
    }
}

struct FaceDisplayView_Previews: PreviewProvider {
    static var previews: some View {
        FaceDisplayView()
    }
}
