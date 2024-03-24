//
//  OrderDetails.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 05.01.2023.
//

import Foundation

struct OrderDetails: Codable, Identifiable {
    var meal: Meal
    var ingredients: [Ingredient] = []
    var quantity: Int
    var subTotal: Float {
        meal.price * Float(quantity)
    }
    var id: UUID
    
    func change(quantity: Int) -> OrderDetails {
        OrderDetails(meal: self.meal, ingredients: ingredients, quantity: quantity, id: self.id)
    }
    
    func change(ingredients: [Ingredient]) -> OrderDetails {
        OrderDetails(meal: self.meal, ingredients: ingredients, quantity: self.quantity, id: self.id)
    }
}

extension OrderDetails {
    static func ==(lhs: OrderDetails, rhs: OrderDetails) -> Bool {
        return (lhs.meal.id == rhs.meal.id) && (lhs.ingredients.id == rhs.ingredients.id)
    }
}

extension [OrderDetails] {
    
    func quantity() -> Int {
        self.map { $0.quantity }.reduce(0, +)
    }
    
    var total: Float {
        self.map { $0.subTotal }.reduce(0, +) + deliveryPrice
    }
    
    var deliveryPrice: Float {
        return 150
    }
}
