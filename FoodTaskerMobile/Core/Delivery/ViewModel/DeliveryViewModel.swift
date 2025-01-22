//
//  DeliveryViewModel.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 24.01.2023.
//

import Foundation
//import SwiftyJSON
import Combine
import SwiftUI

class DeliveryViewModel: ObservableObject {
    @Published var status: Status = .unknown
    @Published var ordersInfo: [OrderInfo] = []
    
    private let ordersService: OrdersService
    
    private let lastOrderStatusService: LastOrderStatusService
    
    var cancellables = Set<AnyCancellable>()
    var timer: AnyCancellable?
    
    init() {
        self.lastOrderStatusService = LastOrderStatusService()
        self.ordersService = OrdersService()
        addPublishers()
    }
    
    func addTimerUpdate() {
        timer = Timer.publish(every: 3, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                self.lastOrderStatusService.getLastStatus()
            }
    }
    
    func removeTimerUpdate() {
        timer = nil
    }
    
    func addPublishers() {
        lastOrderStatusService.$status
            .sink { [weak self] status in
                self?.status = status
                
                if self?.ordersInfo.first != nil {
                    self?.ordersInfo[0].status = status.rawValue
                }
            }
            .store(in: &cancellables)
        
        ordersService.$orders
            .sink { [weak self] orders in
                self?.ordersInfo = orders
            }
            .store(in: &cancellables)
    }
    
    func isCheck(_ cellStatus: Status) -> Bool {
        cellStatus.priority <= status.priority
    }
    
    func isCheck(_ priority: Int) -> Bool {
        priority <= status.priority
    }
    
    func statusColor(_ strStatus: String) -> Color {
        guard let status = Status(rawValue: strStatus) else { return .clear }
        
        switch status {
        case .delivered: return .theme.green
        case .cancelled: return .theme.red
        default: return .yellow
        }
    }
    
    enum Status: String {
        case cancelled = "Отменен"
        case processing = "В обработке"
        case accepted = "Готовиться"
        case ready = "Готов к отправке"
        case onTheWay = "В пути"
        case delivered = "Доставлен"
        case unknown = "Неопределен"
        
        
        var priority: Int {
            switch self {
            case .cancelled:
                return 0
            case .processing:
                return 1
            case .accepted:
                return 2
            case .ready:
                return 3
            case .onTheWay:
                return 4
            case .delivered:
                return 5
            case .unknown:
                return -1
            }
        }
    }
}


