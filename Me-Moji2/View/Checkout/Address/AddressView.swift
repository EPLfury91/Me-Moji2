//
//  AddressView.swift
//  Me-Moji2
//
//  Created by Brett Tracey on 8/8/23.
//

import SwiftUI
import StripePaymentSheet
import Stripe

struct AddressView: View {
   // var x = AddressViewSwift()
   // @EnvironmentObject var helper : Helper
   // @StateObject var helper : Helper = Helper()
   
   
    
    var body: some View {
        VStack{
         //  x
        //    Text(String(let name = x.delegate.addAddress()))
            
        }
    }
            
}


//class Helper: ObservableObject  {
//     @Published var  addressName : AddressViewController.AddressDetails? {
//        willSet {
//                    objectWillChange.send()
//                }
//    }
//    
//    
//    @State var name : String
//    
//
//}
   
class MyViewController: UIResponder, AddressViewControllerDelegate  {
  //  var helper = Helper()
    var addressDetails : AddressViewController.AddressDetails?
    
    func addAddress()->String {
        return addressDetails?.name ?? "n/A"
        
    }
    
}


extension MyViewController {
    
    
    
    public func addressViewControllerDidFinish(_ addressViewController: AddressViewController, with address: AddressViewController.AddressDetails?) {
        addressViewController.dismiss(animated: true)
        
        
        self.addressDetails = address
        addAddress()
        
    }
    
}


struct AddressViewSwift: UIViewControllerRepresentable {
    @Binding var name : String?
    @Binding var address : AddressViewController.AddressDetails.Address?

    typealias UIViewControllerType = AddressViewController
  
     var delegate: MyViewController = MyViewController()
    
    class Coordinator: NSObject, AddressViewControllerDelegate {
        
        var parent : AddressViewSwift
        init(_ parent: AddressViewSwift){
            self.parent = parent
        }
        
        public func addressViewControllerDidFinish(_ addressViewController: AddressViewController, with address: AddressViewController.AddressDetails?) {
            addressViewController.dismiss(animated: true)
            
            
            self.parent.name = address?.name
            self.parent.address = address?.address
            
        }
    }
    
    
   
    
    func setSTPAPAPI () {
        STPAPIClient.shared.publishableKey = "pk_test_51MLoN5Ln6NfP8QkIyweffNkHamevd46IZdUFQundD5CCFD0f7IO0zUu9HjFaQ2GkycyABvxZYKzAGCdroXSr3swp00wey0QPoV"

    }

    let addressConfiguration = AddressViewController.Configuration(
      additionalFields: .init(phone: .required),
      allowedCountries: ["US", "CA", "GB"],
      title: "Shipping Address"

       
    )

    func makeUIViewController(context: Context) -> StripePaymentSheet.AddressViewController {
       //MARK: Need to fix, no way this should be how its done
        self.setSTPAPAPI()
        
        let AddressElement = AddressViewController(configuration: addressConfiguration, delegate: context.coordinator)
        
        AddressElement.delegate = context.coordinator
        return AddressElement
    }

    func updateUIViewController(_ uiViewController: StripePaymentSheet.AddressViewController, context: Context){
        uiViewController.dismiss(animated: true)
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

}







   
