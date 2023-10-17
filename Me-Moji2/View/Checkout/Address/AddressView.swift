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
    @Binding var isTapped : Bool
    @Binding var name2: String?
    @Binding var phone: String?
    @Binding var address: AddressViewController.AddressDetails.Address?

    var body: some View {
        VStack(alignment: .leading){
            VStack(alignment: .leading, spacing: 0){
                Text("Shipping Address")
                    .fontWeight(.bold)
                HStack{
                    Spacer()
                    
                    Button(action:  {
                        self.isTapped = true
                    }, label: {
                        Text("Edit Address")
                    })
                }
                .padding(.trailing)
                    
                AddressDisplayView(text: name2 ?? "n/A")
                AddressDisplayView(text: address?.line1 ?? "n/A")
                AddressDisplayView(text: address?.line2 ?? "n/A")
                HStack{
                    Text(address?.city ?? "n/A")
                    Text( address?.state ?? "n/A")
                    Text(address?.postalCode ?? "n/A")
                    
                }
                AddressDisplayView(text: phone ?? "n/A")
                
                
            }
            
        }
    }
            
}

   
class MyViewController: UIResponder, AddressViewControllerDelegate  {
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
    @Binding var phone: String?

    typealias UIViewControllerType = AddressViewController
  
   //  var delegate: MyViewController = MyViewController()
    
    class Coordinator: NSObject, AddressViewControllerDelegate {
        
        var parent : AddressViewSwift
        init(_ parent: AddressViewSwift){
            self.parent = parent
        }
        
        public func addressViewControllerDidFinish(_ addressViewController: AddressViewController, with address: AddressViewController.AddressDetails?) {
            addressViewController.dismiss(animated: true)
            
            
            self.parent.name = address?.name
            self.parent.address = address?.address
            self.parent.phone = address?.phone
            
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







   
