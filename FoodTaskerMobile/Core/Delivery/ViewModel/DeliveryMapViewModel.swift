//
//  DeliveryMapViewModel.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 28.01.2023.
//

import Foundation
//import SwiftyJSON
import Combine
import SwiftUI
//import MapKit

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
            .sink { addresses in
                self.addresses = addresses
            }
            .store(in: &cancellables)
    }
}

