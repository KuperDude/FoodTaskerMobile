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
    }
    
    func getStatus() async -> DeliveryViewModel.Status? {
        let status = await lastOrderStatusService.getLastStatus()
        return status
    }
    
    func checkToCreateOrder(restaurantId: Int, items: [OrderDetails]) async -> Bool {
        let (url, data) = APIManager.instance.checkToCreateOrder(address: address?.convertToString() ?? "", restaurantId: restaurantId, items: items)
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
