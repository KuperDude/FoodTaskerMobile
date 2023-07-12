//
//  PaymentViewModel.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 13.01.2023.
//

import UIKit
import Combine

class PaymentViewModel: ObservableObject {

    @Published var isShowAlert: Bool = false
    
    var address: String
    var items: [OrderDetails]
    var restaurantId: Int
    
//    var paymentIntentClientSecret: String?
    
    init(address: String, items: [OrderDetails], restaurantId: Int) {
        self.address = address
        self.items = items
        self.restaurantId = restaurantId
    }
    
    func startCheckout(total: Float) {
//        APIManager.instance.createPaymentIntent(total: total) { json in
//            guard let clientSecret = json?["client_secret"] else {
//                return
//            }
//            self.paymentIntentClientSecret = "\(clientSecret)"
//        }
    }
    
    //MARK: - User Intents
    
    private var orderSubscription: AnyCancellable?
    
    func createOrder() async {
        let (url, data) = APIManager.instance.createOrder(address: address, restaurantId: restaurantId, items: items)
        guard let url = url, let data = data else { return }
        await NetworkingManager.send(url: url, data: data)
    }
    
    func placeOrder() {
//        APIManager.instance.getLatestOrder { [weak self] json in
//            if json?["last_order"]["restaurant"]["name"] == "" || json?["last_order"]["status"] == "Delivered" {
//                
//                guard let paymentIntentClientSecret = self?.paymentIntentClientSecret else {
//                    return
//                }
//                let paymentIntentParams = STPPaymentIntentParams(clientSecret: paymentIntentClientSecret)
//                paymentIntentParams.paymentMethodParams = self?.cardParams
//                
//                STPPaymentHandler.shared().confirmPayment(paymentIntentParams, with: self!) { status, paymentIntent, error in
//                    switch status {
//                    case .failed:
//                        print("Payment failed: \(error?.localizedDescription ?? "")")
//                    case .canceled:
//                        print("Payment canceled: \(error?.localizedDescription ?? "")")
//                    case .succeeded:
//                        print("Payment succeded: \(paymentIntent?.description ?? "")")
//                        guard let address = self?.address, let items = self?.items else { return }
//                        
//                        APIManager.instance.createOrder(address: address, restaurantId: 1, items: items) { json in
//                            print(json as Any)
//                        }
//                    @unknown default:
//                        fatalError()
//                    }
//                }
//            } else {
//                self?.isShowAlert = true
//            }
//        }
    }
}
