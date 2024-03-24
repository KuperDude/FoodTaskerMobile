//
//  Ingredient.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 25.05.2023.
//

import Foundation

struct ResponseCode: Codable {
    var code: Int
}

struct ResponseIngredient: Codable {
    var ingredients: [Ingredient]
}

struct Ingredient: Codable, Identifiable, Hashable {
    var id: Int
    var name: String
    var image: String
    var isAdd: Bool = true
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case image
    }
    
    func changeStatus() -> Ingredient {
        return Ingredient(id: id, name: name, image: image, isAdd: !isAdd)
    }
}

extension [Ingredient] {
    
    var id: Int? {
        var s = ""
        for ing in self.sorted(by: { $0.id < $1.id }) {
            if !ing.isAdd {
                s += String(ing.id)
            }
        }
        return Int(s)
    }
}
