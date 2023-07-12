//
//  DeliveryViewModel.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 24.01.2023.
//

import Foundation
import SwiftyJSON
import Combine
import SwiftUI

class DeliveryViewModel: ObservableObject {
    @Published var status: Status = .processing
    
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
            .sink { status in
                self.status = status
            }
            .store(in: &cancellables)
    }
    
    func isCheck(_ cellStatus: Status) -> Bool {
        cellStatus.priority <= status.priority
    }
    
    enum Status: String {
        case processing = "Processing"
        case accepted = "Cooking"
        case ready = "Ready"
        case onTheWay = "On the way"
        case delivered = "Delivered"
        
//        "Order accepted"
//        case ready = "Food ready"
//        case onTheWay = "Courier is on the way"
//        case delivered = "Delivered"
        
        var priority: Int {
            switch self {
            case .processing:
                return 0
            case .accepted:
                return 1
            case .ready:
                return 2
            case .onTheWay:
                return 3
            case .delivered:
                return 4
            }
        }
    }
}


