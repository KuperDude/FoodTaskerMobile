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
    @Published var orders: [String] = []
    
    private var lastOrderSubscription: AnyCancellable?
    
    init() {
        getOrders()
    }
    
    func getOrders() {
        guard let url = APIManager.instance.getOrders() else { return }
        
        lastOrderSubscription = NetworkingManager.download(url: url)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { status in
                switch status {
                case .failure(let error): print(error)
                case .finished: break
                }
            }, receiveValue: { data in
                let jsonData = JSON(data)
                let orders = jsonData["orders"]
                
                guard let date = orders["created_at"].string else { return }
                guard let total = orders["total"].string else { return }
                
                print(data)
            })
    }
}
