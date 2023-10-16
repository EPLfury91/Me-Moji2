//
//  WelcomeView.swift
//  Me-Moji2
//
//  Created by Brett Tracey on 9/30/23.
//

import SwiftUI
import FirebaseAuth

enum WelcomeScreenFlow {
    case Welcome
    case Instructions
}

struct WelcomeViewFlow: View {
    @EnvironmentObject var model: ContentModel
    @State var mainScreen : WelcomeScreenFlow
    @State var isPresented = false
    
    var body: some View {
        NavigationView{
            
            VStack{
                switch mainScreen {
                case .Welcome: WelcomeView(mainScreen: $mainScreen)
                case .Instructions: InstructionsView(mainscreen: $mainScreen)
                }
            }
            .toolbar {
                    Button(action: {
                        model.dismissSheet()
                    }, label:{
                        XbuttonView()
                    })
                
            }
        }
    }
}


struct WelcomeView: View {
    @EnvironmentObject var model: ContentModel
    
    @State private var isAnimating = false
    @State private var XAnimating = false
    @State var wordArray = ["Hello,", Auth.auth().currentUser?.displayName ?? "Not There"]
    @State var wordArray1 = ["Lets", "get", "started!"]
    @Binding var mainScreen : WelcomeScreenFlow
    
    @State var fraction = 0.9
    
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
            
            Button {
                mainScreen = .Instructions
            } label: {
                Text("Next")
                    .modifier(HorizantalOffsetModifier(isAnimating: XAnimating, fraction: fraction))
                    .animation(.easeInOut(duration: 2.0).delay(2.5), value: XAnimating)
            }
            
        }
        .task {
            self.isAnimating.toggle()
            self.XAnimating.toggle()
        }
    }
}

struct HorizantalOffsetModifier: GeometryEffect {
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
        let offset = size.width * 100
        return ProjectionTransform(CGAffineTransform(translationX: offset * (fraction - percentage),
                                                     y: 0.0))
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

