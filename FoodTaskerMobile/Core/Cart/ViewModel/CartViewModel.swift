//
//  CartViewModel.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 22.03.2024.
//

import Foundation
import Combine

class CartViewModel: ObservableObject {
    private var status: DeliveryViewModel.Status = .processing
    
    private let lastOrderStatusService: LastOrderStatusService
    
    var cancellables = Set<AnyCancellable>()
    
    
    init() {
        self.lastOrderStatusService = LastOrderStatusService()
        addPublishers()
    }
    
    func addPublishers() {
        Timer.publish(every: 3, on: .main, in: .common)
            .autoconnect()
            .sink { _ in                
                self.lastOrderStatusService.getLastStatus()
            }
            .store(in: &cancellables)
        
        lastOrderStatusService.$status
            .sink { [weak self] status in
                self?.status = status
            }
            .store(in: &cancellables)
    }
    
    func getStatus() -> DeliveryViewModel.Status {
        return status
    }
}
