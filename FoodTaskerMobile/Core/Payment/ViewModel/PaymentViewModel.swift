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
    
    var address: Address?
    var items: [OrderDetails]
    var restaurantID: Int?
    var deliveryPrice: Float
    
    init(address: Address?, items: [OrderDetails], restaurantID: Int?, deliveryPrice: Float) {
        self.address = address
        self.items = items
        self.restaurantID = restaurantID
        self.deliveryPrice = deliveryPrice
    }
    
    //MARK: - User Intents
    
    private var orderSubscription: AnyCancellable?
    
    func createOrder() async {
        guard let restaurantID = restaurantID else { return }
        let (url, data) = APIManager.instance.createOrder(address: address?.convertToString() ?? "", restaurantId: restaurantID, deliveryPrice: deliveryPrice, items: items)
        guard let url = url, let data = data else { return }
        await NetworkingManager.send(url: url, data: data)
    }
}
