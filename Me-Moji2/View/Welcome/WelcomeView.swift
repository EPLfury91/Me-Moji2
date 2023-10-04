//
//  WelcomeView.swift
//  Me-Moji2
//
//  Created by Brett Tracey on 9/30/23.
//

import SwiftUI

enum WelcomeScreenFlow {
    case Welcome
    case Instructions
}

struct WeclomeViewFlow: View {
    @State var mainScreen : WelcomeScreenFlow
    
    var body: some View {
        VStack{
            switch mainScreen {
            case .Welcome: WelcomeView(mainScreen: $mainScreen)
            case .Instructions: InstructionsView(mainscreen: $mainScreen)
            }
        }
    }
}


struct WelcomeView: View {
    @State private var isAnimating = false
    @State var wordArray = ["Hello,", "Brett!"]
    @State var wordArray1 = ["Lets", "get", "started!"]
    @Binding var mainScreen : WelcomeScreenFlow
    
    var body: some View {
        VStack {
            HStack{
                ForEach(wordArray.indices, id: \.self) { index in
                    let fraction = CGFloat(Double(index) + 0.5) / CGFloat(wordArray.count)
                    Text(wordArray[index])
                        .modifier(VerticalOffsetModifier(isAnimating: isAnimating, fraction: fraction))
                        .animation(.easeInOut(duration: 2.0), value: isAnimating)
                        
                }
            }
            
            HStack{
                ForEach(wordArray1.indices, id: \.self) { index in
                    let fraction = CGFloat(Double(index) + 0.9) / CGFloat(wordArray1.count)
                    Text(wordArray1[index])
                        .modifier(VerticalOffsetModifier(isAnimating: isAnimating, fraction: fraction))
                        .animation(.easeInOut(duration: 2.0).delay(1.5), value: isAnimating)
                        
                }
              
            }
        }
        .task {
            self.isAnimating.toggle()
        }
        .toolbar(content: {
            Button {
                mainScreen = .Instructions
            } label: {
                Text("Next")
            }

        })
    }
        
        
        
}
    

struct VerticalOffsetModifier: GeometryEffect {
    private var percentage: CGFloat
    private var fraction: CGFloat
    
    var animatableData: CGFloat {
        get {percentage}
        set {percentage = newValue}
    }
        
    init(isAnimating: Bool, fraction: CGFloat) {
        self.percentage = isAnimating ? 1.0 : 0.0
        self.fraction = fraction
            
    }
    func effectValue(size: CGSize) -> ProjectionTransform {
        guard percentage <= fraction else {
            return ProjectionTransform(.identity)
        }
        let offset = size.height * 100
        return ProjectionTransform(CGAffineTransform(translationX: 0.0,
                                                     y: offset * (fraction - percentage)))
    }
}

