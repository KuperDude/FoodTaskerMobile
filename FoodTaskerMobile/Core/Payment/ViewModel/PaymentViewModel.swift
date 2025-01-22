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
    var restaurantTitle: String
    var deliveryPrice: Float
    
    init(address: Address?, items: [OrderDetails], restaurantTitle: String, deliveryPrice: Float) {
        self.address = address
        self.items = items
        self.restaurantTitle = restaurantTitle
        self.deliveryPrice = deliveryPrice
    }
    
    //MARK: - User Intents
    
    private var orderSubscription: AnyCancellable?
    
    func createOrder() async {
        guard let restaurantId = try? await APIManager.instance.getRestaurantID(at: restaurantTitle) else { return }
        let (url, data) = APIManager.instance.createOrder(address: address?.convertToString() ?? "", restaurantId: restaurantId, deliveryPrice: deliveryPrice, items: items)
        guard let url = url, let data = data else { return }
        await NetworkingManager.send(url: url, data: data)
    }
}
