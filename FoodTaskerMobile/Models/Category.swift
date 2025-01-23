//
//  Category.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 08.04.2023.
//

import Foundation

struct Category: Codable, Identifiable, Hashable {
    var id: Int
    var name: String
    var order: Int
}
