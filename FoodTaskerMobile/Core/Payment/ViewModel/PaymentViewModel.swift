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
    var restaurantId: Int
    
    init(address: Address?, items: [OrderDetails], restaurantId: Int) {
        self.address = address
        self.items = items
        self.restaurantId = restaurantId
    }
    
    //MARK: - User Intents
    
    private var orderSubscription: AnyCancellable?
    
    func createOrder() async {
        let (url, data) = APIManager.instance.createOrder(address: address?.convertToString() ?? "", restaurantId: restaurantId, items: items)
        guard let url = url, let data = data else { return }
        await NetworkingManager.send(url: url, data: data)
    }
}
