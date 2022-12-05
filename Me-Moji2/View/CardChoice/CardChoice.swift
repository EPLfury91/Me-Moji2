//
//  CardChoice.swift
//  Me-Moji2
//
//  Created by Brett Tracey on 12/4/22.
//

import SwiftUI

struct CardChoice: View {
    @State var eventSelection = 0
    
    var body: some View {
        VStack(alignment: .leading){
            
            //TO DO: Why isnt vstack leading alignment??
            HStack{
                Picker("", selection: $eventSelection){
                    Text("Birthday")
                        .tag(0)
                    Text("Anniversary")
                        .tag(1)
                    Text("Christmas")
                        .tag(2)
                }
                .pickerStyle(.menu)
                Spacer()
            }
            
            Spacer()
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        }
    }
}

struct CardChoice_Previews: PreviewProvider {
    static var previews: some View {
        CardChoice()
    }
}
