//
//  OrderService.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 09.03.2024.
//

import Foundation
import Combine
import SwiftyJSON

class OrdersService {
    @Published var orders: [OrderInfo] = []
    
    private var ordersSubscription: AnyCancellable?
    
    init() {
        getOrders()
    }
    
    func getOrders() {
        guard let url = APIManager.instance.getOrders() else { return }
        
        ordersSubscription = NetworkingManager.download(url: url)
            .decode(type: ResponseOrderInfo.self, decoder: JSONDecoder())
            .map { response in response.orders }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { status in
                switch status {
                case .failure(let error): print(error)
                case .finished: break
                }
            }, receiveValue: { orders in
                self.orders = orders
                print(orders)
            })
    }
}
