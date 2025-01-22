//
//  CartViewModel.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 22.03.2024.
//

import Foundation
import Combine
import SwiftyJSON

class CartViewModel: ObservableObject {
    private var status: DeliveryViewModel.Status = .processing
    private let lastOrderStatusService: LastOrderStatusService
    
    var address: Address?
    
    var cancellables = Set<AnyCancellable>()
    
    @Published var errorDescription: String? = nil
    
    enum Status: String {
        case success
        case failed
    }
    
    init() {
        self.lastOrderStatusService = LastOrderStatusService()
        addPublishers()
    }
    
    func addPublishers() {
//        Timer.publish(every: 3, on: .main, in: .common)
//            .autoconnect()
//            .sink { _ in                
//                self.lastOrderStatusService.getLastStatus()
//            }
//            .store(in: &cancellables)
        
        lastOrderStatusService.$status
            .sink { [weak self] status in
                self?.status = status
            }
            .store(in: &cancellables)
    }
    
    func getStatus() -> DeliveryViewModel.Status {
        return status
    }
    
    func checkToCreateOrder() async -> Bool {
        let (url, data) = APIManager.instance.checkToCreateOrder(address: address?.convertToString() ?? "")
        guard let url = url, let data = data else {
            errorDescription = "Что-то пошло не так..."
            return false
        }
        let result = await NetworkingManager.send(url: url, data: data)
        
        switch result {
        case .failure(let error):
            errorDescription = error.localizedDescription
        case .success(let data):
            let jsonData = JSON(data)
            guard
                let stringStatus = jsonData["status"].string,
                let status = Status(rawValue: stringStatus)
            else {
                errorDescription = "Что-то пошло не так..."
                return false
            }
            
            switch status {
            case .success:
                return true
            case .failed:
                guard let error = jsonData["error"].string else {
                    errorDescription = "Что-то пошло не так..."
                    return false
                }
                errorDescription = error
                return false
            }
        }
        errorDescription = "Что-то пошло не так..."
        return false
    }
}
