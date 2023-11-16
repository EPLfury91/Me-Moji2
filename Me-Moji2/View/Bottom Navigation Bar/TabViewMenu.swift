//
//  TabViewMenu.swift
//  Me-Moji2
//
//  Created by Brett Tracey on 5/28/23.
//

import SwiftUI

struct TabViewMenu: View {
    @State var selection = 0
    
    var body: some View {
        ZStack {
            Picker("", selection: $selection){
                Image(systemName: "cart")
                    .tag(0)
                Image(systemName: "person")
                    .tag(1)
               
            }
            .pickerStyle(.segmented)
        }
       
    }
}

struct TabViewMenu_Previews: PreviewProvider {
    static var previews: some View {
        TabViewMenu()
    }
}
