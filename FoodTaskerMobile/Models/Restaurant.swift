//
//  Restaurant.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 29.12.2022.
//

import Foundation

struct Restaurant: Codable, Identifiable {
    var id: Int
    var name: String
    var address: String
    var logo: String
}

struct ResponseRestaurant: Codable {
    var restaurants: [Restaurant]
}
