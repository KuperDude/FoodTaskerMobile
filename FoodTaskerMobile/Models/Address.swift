//
//  Address.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 31.07.2023.
//

import Foundation

struct Address: Equatable, Identifiable {
    var id: UUID = UUID()
    var street: String
    var house: String
    var floor: String
    var apartmentNumber: String
    var intercom: String //домофон
    var entrance: String //подъезд
    var comment: String
    var lastUpdateDate = Date.now
    
    var isStreetAndHouseFill: Bool {
        house != "" && street != ""
    }
    
    init(entity: AddressEntity) {
        self.id = entity.addressID ?? UUID()
        self.street = entity.street ?? ""
        self.house = entity.house ?? ""
        self.floor = entity.floor ?? ""
        self.apartmentNumber = entity.apartmentNumber ?? ""
        self.intercom = entity.intercom ?? ""
        self.entrance = entity.entrance ?? ""
        self.comment = entity.comment ?? ""
        self.lastUpdateDate = entity.lastUpdateDate ?? Date.now
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
    
    init(id: UUID = UUID(), street: String, house: String, floor: String, apartmentNumber: String, intercom: String, entrance: String, comment: String, lastUpdateDate: Date = Date.now) {
        self.street = street
        self.house = house
        self.floor = floor
        self.apartmentNumber = apartmentNumber
        self.intercom = intercom
        self.entrance = entrance
        self.comment = comment
        self.lastUpdateDate = lastUpdateDate
    }
    
    func changeStreetAndHouse(street: String, house: String) -> Address {
        Address(id: self.id, street: street, house: house, floor: self.floor, apartmentNumber: self.apartmentNumber, intercom: self.intercom, entrance: self.entrance, comment: self.comment, lastUpdateDate: self.lastUpdateDate)
    }
    
    func convertToString() -> String {
        "\(street) \(house)"
    }
    
    func isEmpty() -> Bool {
        street.isEmpty || house.isEmpty
    }
}

