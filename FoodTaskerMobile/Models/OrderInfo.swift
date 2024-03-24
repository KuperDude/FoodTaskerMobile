//
//  OrderInfo.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 10.03.2024.
//

import Foundation

struct ResponseOrderInfo: Codable {
    var orders: [OrderInfo]
}

struct OrderInfo: Codable, Identifiable {
    var id: Int
    var date: String
    var status: String
    var total: Float
    
    private enum CodingKeys: String, CodingKey {
        case id
        case date = "created_at"
        case status
        case total
    }
}
