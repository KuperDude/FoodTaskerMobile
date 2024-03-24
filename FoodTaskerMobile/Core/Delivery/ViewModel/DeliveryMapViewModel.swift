//
//  DeliveryMapViewModel.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 28.01.2023.
//

import Foundation
import Combine
import SwiftUI

class DeliveryMapViewModel: ObservableObject {
    @Published var addresses: [String] = []
    
    private let lastOrderService: LastOrderService
    
    var cancellables = Set<AnyCancellable>()
    
    init() {
        self.lastOrderService = LastOrderService()
        addPublishers()
    }
    
    func addPublishers() {
        lastOrderService.$addresses
            .sink { [weak self] addresses in
                self?.addresses = addresses
            }
            .store(in: &cancellables)
    }
}

