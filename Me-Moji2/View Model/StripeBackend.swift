//
//  StripeBackend.swift
//  Me-Moji2
//
//  Created by Brett Tracey on 2/20/23.
//


import Foundation
import Stripe
import UIKit
import FirebaseFunctions

class MyStripeAPIClient: NSObject, STPCustomerEphemeralKeyProvider  {
    
    lazy var functions = Functions.functions()
    
    func createCustomerKey(withAPIVersion apiVersion: String, completion: @escaping STPJSONResponseCompletionBlock) {
//        if let profile = currentProfile {
//            functions.httpsCallable("getStripeEphemeralKeys").call(["api_version" : apiVersion, "customer_id" : profile.stripe_customer_id]) { (response, error) in
//                if let error = error {
//                    print(error)
//                    completion(nil, error)
//                }
//                if let response = (response?.data as? [String: Any]) {
//                    completion(response, nil)
//                    print("MyStripeAPIClient response \(response)")
//                }
//            }
//        }
//
    }
}





//class PaymentsViewController: UIViewController, STPPaymentContextDelegate {
//    var paymentContext: STPPaymentContext
//
//    override func viewDidLoad() {
//        let customerContext = STPCustomerContext(keyProvider: MyStripeAPIClient())
//        self.paymentContext = STPPaymentContext(customerContext: customerContext)
//        self.paymentContext.delegate = self
//        self.paymentContext.hostViewController = self
//        self.paymentContext.paymentAmount = 100
//
//        self.paymentContext.pushPaymentOptionsViewController()
//    }
//
//    init() {
//        let customerContext = STPCustomerContext(keyProvider: MyStripeAPIClient())
//        self.paymentContext = STPPaymentContext(customerContext: customerContext)
//        super.init(nibName: nil, bundle: nil)
//        self.paymentContext.delegate = self
//        self.paymentContext.hostViewController = self
//        self.paymentContext.paymentAmount = 100
//
//        self.paymentContext.pushPaymentOptionsViewController()
//    }
//
//    required init?(coder: NSCoder) {
////        self.paymentContext = STPPaymentContext()
////        super.init(coder: coder)
//    }
//
//
//    func paymentContextDidChange(_ paymentContext: STPPaymentContext) {
//
//    }
//
//    func paymentContext(_ paymentContext: STPPaymentContext, didFailToLoadWithError error: Error) {
//
//    }
//
//    func paymentContext(_ paymentContext: STPPaymentContext, didCreatePaymentResult paymentResult: STPPaymentResult, completion: @escaping STPPaymentStatusBlock) {
//
//    }
//
//    func paymentContext(_ paymentContext: STPPaymentContext, didFinishWith status: STPPaymentStatus, error: Error?) {
//
//    }
//
//
//
//}




