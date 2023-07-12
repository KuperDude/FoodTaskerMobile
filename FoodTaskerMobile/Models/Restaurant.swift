//
//  Restaurant.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 29.12.2022.
//

import Foundation

struct ResponseRestaurant: Codable {
    var restaurants: [Restaurant]
}

struct Restaurant: Codable, Identifiable {
    var id: Int
    var name: String
    var address: String
    var logo: String
}
