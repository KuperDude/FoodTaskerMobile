//
//  Meal.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 01.01.2023.
//

import Foundation

struct Meal: Codable, Identifiable {
    var id: Int
    var name: String
    var shortDescription: String
    var image: String
    var price: Float
    var category: Category
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case shortDescription = "short_description"
        case image
        case price
        case category
    }
}

struct ResponseMeal: Codable {
    var meals: [Meal]
}
