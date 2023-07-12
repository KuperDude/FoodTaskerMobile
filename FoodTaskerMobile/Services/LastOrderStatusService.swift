//
//  LastOrderStatusService.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 28.01.2023.
//

import Foundation
import Combine
import SwiftyJSON

class LastOrderStatusService {
    
    @Published var status: DeliveryViewModel.Status = .processing
    
    private var lastOrderSubscription: AnyCancellable?
    
    init() {
        getLastStatus()
    }
    
    func getLastStatus() {
        guard let url = APIManager.instance.getLatestOrderStatus() else { return }
        
        lastOrderSubscription = NetworkingManager.download(url: url)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { status in
                switch status {
                case .failure(let error): print(error)
                case .finished: break
                }
            }, receiveValue: { data in
                let jsonData = JSON(data)
                guard
                    let stringStatus = jsonData["last_order_status"]["status"].string,
                    let status = DeliveryViewModel.Status(rawValue: stringStatus)
                else {
                    return
                }
                self.status = status
            })
    }
}
