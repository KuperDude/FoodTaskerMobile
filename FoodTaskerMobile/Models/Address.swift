//
//  Address.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 31.07.2023.
//

import Foundation

struct Address: Equatable {
    var street: String
    var house: String
    var floor: String
    var apartmentNumber: String
    var intercom: String //домофон
    var entrance: String //подъезд
    var comment: String
    
    var isStreetAndHouseFill: Bool {
        house != "" && street != ""
    }
    
    init() {
        self.street = ""
        self.house = ""
        self.floor = ""
        self.apartmentNumber = ""
        self.intercom = ""
        self.entrance = ""
        self.comment = ""
    }
    
    init(street: String, house: String, floor: String, apartamentNumber: String, intercom: String, entrance: String, comment: String) {
        self.street = street
        self.house = house
        self.floor = floor
        self.apartmentNumber = apartamentNumber
        self.intercom = intercom
        self.entrance = entrance
        self.comment = comment
    }
    
    func changeStreetAndHouse(street: String, house: String) -> Address {
        Address(street: street, house: house, floor: self.floor, apartamentNumber: self.apartmentNumber, intercom: self.intercom, entrance: self.entrance, comment: self.comment)
    }
    
    func convertToString() -> String {
        "\(street) \(house) \(floor) \(apartmentNumber)"
    }
    
    func isEmpty() -> Bool {
        street.isEmpty || house.isEmpty
    }
}
