//
//  LastOrderService.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 28.01.2023.
//

import Foundation
import Combine
import SwiftyJSON

class LastOrderService {
    @Published var addresses: [String] = []
    
    private var lastOrderSubscription: AnyCancellable?
    
    init() {
        getLastOrder()
    }
    
    func getLastOrder() {
        guard let url = APIManager.instance.getLatestOrder() else { return }
        
        lastOrderSubscription = NetworkingManager.download(url: url)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { status in
                switch status {
                case .failure(let error): print(error)
                case .finished: break
                }
            }, receiveValue: { data in
                let jsonData = JSON(data)
                let order = jsonData["last_order"]
                
                guard let from = order["restaurant"]["address"].string else { return }
                guard let to = order["address"].string else { return }
                
                self.addresses = [from, to]
            })
    }
}
