//
//  ProfileUpdateView.swift
//  Me-Moji2
//
//  Created by Brett Tracey on 10/31/23.
//

import SwiftUI
import Firebase

enum update: Hashable {
    case email
    case password
    case profileInfo
}

struct ProfileUpdateView: View {
    @EnvironmentObject var model: ContentModel
    @Binding var mainScreen: MainScreen
    var user = Auth.auth().currentUser
    
    var body: some View {
        
        List{
            NavigationLink{
                updateView(displayValue1: user!.displayName!, displayValue2: model.list.LastName, update: update.profileInfo)
            } label: {
                ListView(title: "Name", currentValue: model.list.FirstName + " " + model.list.LastName)
            }
          
            NavigationLink {
                updateView(displayValue1: user!.email!, displayValue2: "", update: update.email)
                    
            } label: {
                ListView(title: "Email", currentValue: user!.email!)
            }

            NavigationLink {
                updateView(displayValue1: user!.displayName!,displayValue2: "", update: update.password)
            } label: {
                ListView(title: "Password", currentValue: "")
            }
        }
        .toolbar(content: {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    mainScreen = .Profile
                } label: {
                    Text("Back")
                }
            }
        })
    }
}


struct ListView: View {
    @State var title: String
    @State var currentValue: String
    
    var body: some View {
        VStack(alignment: .leading){
            Text(title)
                .fontWeight(.bold)
                .foregroundStyle(Color("Myscheme"))
            Text(currentValue)
                .fontWeight(.medium)
                .foregroundStyle(Color("Myscheme"))
        }
    }
}


struct updateView: View {
    @EnvironmentObject var model: ContentModel
    @State var change1: String = ""
    @State var change2: String = ""
    @State var displayValue1: String
    @State var displayValue2: String
    @State var update: update
    @State var Message = ""

    var body: some View{
        VStack{
            
            switch update{
            case .profileInfo:  profileInfoUpdateView(change1: $change1, change2: $change2, displayValue1: displayValue1, displayValue2: displayValue2)
            case.password: passwordUpdateView(change1: $change1, change2: $change2, displayValue1: displayValue1, displayValue2: displayValue2)
            case.email: emailUpdateView(change1: $change1, displayValue1: displayValue1)
            
            }
           
        }
        .onDisappear(perform: {
            model.removeListner()
        })
    }
}

struct passwordUpdateView: View{
    @EnvironmentObject var model: ContentModel
    @Binding var change1: String
    @Binding var change2: String
    @State var displayValue1: String
    @State var displayValue2: String
    @State var Message: String = ""
    @State var isPresented = false
    
    var body: some View{
        VStack{
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(lineWidth: 2)
                        .frame(width: UIScreen.main.bounds.width - 20, height: 50, alignment: .center)
                        .foregroundColor(Color("Myscheme"))
                    
                    SecureField(text: $change1, prompt: Text("Type New Password")) {
                        Text("\(displayValue1)")
                            .foregroundColor(Color("Myscheme"))
                           
                    }
                    .padding(.leading, 10)
                    .frame(width: UIScreen.main.bounds.width - 30, height: 50, alignment: .center)
                }
               
               
                
                ZStack{
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(lineWidth: 2)
                        .frame(width: UIScreen.main.bounds.width - 20, height: 50, alignment: .center)
                        .foregroundColor(Color("Myscheme"))
                    
                    SecureField(text: $change2, prompt: Text("Retype Password")) {
                        Text("\(displayValue1)")
                            .foregroundColor(Color("Myscheme"))
                            
                    }
                    .frame(width: UIScreen.main.bounds.width - 30, height: 50, alignment: .center)
                    .padding(.leading, 10)
                }
            Button {
                Task{
                    do{
                        Message = try await model.updatePassword(password: change1)
                        self.isPresented = true
                    } catch {
                        Message = error.localizedDescription
                        self.isPresented = true
                    }
                }
               
            } label: {
                buttonDisplay(buttonLabel: "Update Password", isDisabled: change1 != change2 || model.emptyString(checkString: change1))
            }
            .alert(Message, isPresented: $isPresented, actions: {Button(action: {Text(Message)}, label: {
                Text("Ok")
            })})
            .disabled(change1 != change2 || model.emptyString(checkString: change1))

        }
    }
}

struct emailUpdateView: View{
    @EnvironmentObject var model: ContentModel
    @Binding var change1: String
    @State var displayValue1: String
    @State var Message = ""
    @State var EmailisPresented = false
    
    var body: some View{
        VStack{
            ZStack {
              RoundedRectangle(cornerRadius: 10)
                  .stroke(lineWidth: 2)
                  .frame(width: UIScreen.main.bounds.width - 20, height: 50, alignment: .center)
                  .foregroundColor(.blue)
              
              TextField(text: $change1, prompt: Text("\(displayValue1)")) {
                  Text("\(displayValue1)")
                      .foregroundColor(Color("Myscheme"))
              }
              .frame(width: UIScreen.main.bounds.width - 30, height: 50, alignment: .center)
          }
            Button {
                Task{
                    do {
                        Message = try await model.updateEmail(email: change1)
                        //Message = "Email updated successfully"
                        EmailisPresented = true
                    } catch {
                        Message = error.localizedDescription
                    }
                }
               
            } label: {
                buttonDisplay(buttonLabel: "Update Email", isDisabled: model.emptyString(checkString: change1))
            }
            .alert(Message, isPresented: $EmailisPresented, actions: {Button(action: {Text(Message)}, label: {
                Text("Ok")
            })})
            
        }
    }
    
}

struct profileInfoUpdateView: View{
    @EnvironmentObject var model: ContentModel
    @Binding var change1: String
    @Binding var change2: String
    @State var displayValue1: String
    @State var displayValue2: String
    @State var Message: String = ""
    @State var isPresented = false
    var error1: ErrorMessage?
    
    
    var body: some View{
        VStack{
            ZStack {
              RoundedRectangle(cornerRadius: 10)
                  .stroke(lineWidth: 2)
                  .frame(width: UIScreen.main.bounds.width - 20, height: 50, alignment: .center)
                  .foregroundColor(.blue)
              
              TextField(text: $change1, prompt: Text("\(displayValue1)")) {
                  Text("\(displayValue1)")
                      .foregroundColor(.primary)
              }
              .frame(width: UIScreen.main.bounds.width - 30, height: 50, alignment: .center)
          }
            ZStack {
              RoundedRectangle(cornerRadius: 10)
                  .stroke(lineWidth: 2)
                  .frame(width: UIScreen.main.bounds.width - 20, height: 50, alignment: .center)
                  .foregroundColor(.blue)
              
              TextField(text: $change2, prompt: Text("\(displayValue2)")) {
                  Text("\(displayValue2)")
                      .foregroundColor(.primary)
              }
              .frame(width: UIScreen.main.bounds.width - 30, height: 50, alignment: .center)
          }
            Button {
                Task{ 
                    do {
                         try await model.updateFirebaseName(firstName: change1, lastName: change2, displayFirst: displayValue1, displayLast: displayValue2)
                        
                         Message = "Update Succesful"
                         model.removeListner()
                         model.fetchData()
                         
                     }catch{
                         Message = error.localizedDescription   
                     }
                    self.isPresented = true
                }
               
            } label: {
                buttonDisplay(buttonLabel: "Update Name", isDisabled: false)
            }
            .alert(Message, isPresented: $isPresented, actions: {Button(action: {Text(Message)}, label: {
                Text("Ok")
            })})
            
        }
       

    }
    
}
