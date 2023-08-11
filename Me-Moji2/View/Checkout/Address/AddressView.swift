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
    var body: some View {
        AddressViewSwift()
    }
}

class MyViewController: AddressViewControllerDelegate {
    
  //  let addresViewController = AddressViewController(configuration: addressConfiguration, delegate: self)
    
}

extension MyViewController {
    
    public func addressViewControllerDidFinish(_ addressViewController: AddressViewController, with address: AddressViewController.AddressDetails?) {
        addressViewController.dismiss(animated: true)
      //  self.addressDetails = address
    }
    
    
}


struct AddressViewSwift: UIViewControllerRepresentable {

    typealias UIViewControllerType = AddressViewController
  
    weak var delegate: AddressViewControllerDelegate? = nil
    
    
    func setSTPAPAPI () {
        STPAPIClient.shared.publishableKey = "pk_test_51MLoN5Ln6NfP8QkIyweffNkHamevd46IZdUFQundD5CCFD0f7IO0zUu9HjFaQ2GkycyABvxZYKzAGCdroXSr3swp00wey0QPoV"

    }
  //  self.setSTPAPAPI()
    
    
    let addressConfiguration = AddressViewController.Configuration(
      additionalFields: .init(phone: .required),
      allowedCountries: ["US", "CA", "GB"],
      title: "Shipping Address"
    )

    

    func makeUIViewController(context: Context) -> StripePaymentSheet.AddressViewController {
       //MARK: Need to fix, no way this should be how its done
        self.setSTPAPAPI()
        
        let AddressElement = AddressViewController(configuration: addressConfiguration, delegate: MyViewController())


        return AddressElement
    }

    func updateUIViewController(_ uiViewController: StripePaymentSheet.AddressViewController, context: Context) {
        
        
        uiViewController.dismiss(animated: true)
    }

}






   
