//
//  OrderDetailsSerializer.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 19.02.2023.
//

import Foundation

struct OrderDetailsSerializer: Codable {
    var mealId: Int
    var quantity: Int
    
    private enum CodingKeys: String, CodingKey {
        case mealId = "meal_id"
        case quantity
    }
}
