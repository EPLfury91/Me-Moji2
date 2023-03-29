//
//  ErrorView.swift
//  Me-Moji2
//
//  Created by Brett Tracey on 3/29/23.
//

import SwiftUI

struct ErrorView: View {
    @EnvironmentObject var model: ContentModel
    
    var body: some View {
        Text(model.errorMessage)
    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView()
    }
}
