//
//  User.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 28.12.2022.
//

import SwiftUI

struct ResponseUser: Codable {
    var users: [User]
    
    private enum CodingKeys: String, CodingKey {
        case users = "response"
    }
}

struct User: Codable, Identifiable, Equatable {
    var id: Int
    var firstName: String
    var lastName: String
    var imageURL: String
    
    private enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case imageURL = "photo_50"
    }
    
    var fullName: String {
        return firstName + " " + lastName
    }
}

