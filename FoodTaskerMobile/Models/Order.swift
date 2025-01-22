//
//  Order.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 19.02.2023.
//

import Foundation

struct Order: Codable {
    var accessToken: String
    var restaurantId: Int
    var address: String
    var orderDetails: [OrderDetailsSerializer]
    var deliveryPrice: Float
    
    private enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case restaurantId = "restaurant_id"
        case address
        case orderDetails = "order_details"
        case deliveryPrice = "delivery_price"
    }
}
