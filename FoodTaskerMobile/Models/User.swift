//
//  User.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 28.12.2022.
//

import SwiftUI

struct User: Codable, Identifiable, Equatable {
    var id: String
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

struct ResponseUser: Codable {
    var users: [ResUser]
    
    private enum CodingKeys: String, CodingKey {
        case users = "response"
    }
}

struct ResUser: Codable, Identifiable, Equatable {
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
    
    func convertToUser() -> User {
        User(id: String(self.id), firstName: self.firstName, lastName: self.lastName, imageURL: self.imageURL)
    }
}

struct MailResponseUser: Codable, Equatable {
    var user: MailUser
    
    private enum CodingKeys: String, CodingKey {
        case user = "user"
    }
}

struct MailUser: Codable, Identifiable, Equatable {
    var id: Int
    var username: String

    func convertToUser() -> User {
        User(id: String(self.id), firstName: self.username, lastName: "", imageURL: "")
    }
}

