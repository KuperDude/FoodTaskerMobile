//
//  LastOrderStatusService.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 28.01.2023.
//

import Foundation
import SwiftyJSON

class LastOrderStatusService {
    
    func getLastStatus() async -> DeliveryViewModel.Status? {
        guard let url = APIManager.instance.getLatestOrderStatus() else { return nil }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let jsonData = JSON(data)
            
            guard
                let stringStatus = jsonData["last_order_status"]["status"].string,
                let status = DeliveryViewModel.Status(rawValue: stringStatus)
            else {
                return nil
            }
            return status
        } catch {
            print(error)
        }
        return nil
    }

}
