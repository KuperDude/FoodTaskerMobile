//
//  Address.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 31.07.2023.
//

import Foundation

struct Address: Equatable, Identifiable, Codable {
    var id: Int? = nil
    var city: String = ""
    var street: String
    var house: String
    var floor: String = ""
    var apartmentNumber: String = ""
    var intercom: String = "" //домофон
    var entrance: String = "" //подъезд
    var comment: String = ""
    var lastUpdateDate = Date.now
    
    enum CodingKeys: String, CodingKey {
        case id
        case city
        case street
        case house
        case floor
        case apartmentNumber = "apartment_number"
        case intercom
        case entrance
        case comment
        case lastUpdateDate = "last_update_date"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try values.decodeIfPresent(Int.self, forKey: .id)
        self.city = try values.decodeIfPresent(String.self, forKey: .city) ?? ""
        self.street = try values.decodeIfPresent(String.self, forKey: .street) ?? ""
        self.house = try values.decodeIfPresent(String.self, forKey: .house) ?? ""
        self.floor = try values.decodeIfPresent(String.self, forKey: .floor) ?? ""
        self.apartmentNumber = try values.decodeIfPresent(String.self, forKey: .apartmentNumber) ?? ""
        self.intercom = try values.decodeIfPresent(String.self, forKey: .intercom) ?? ""
        self.entrance = try values.decodeIfPresent(String.self, forKey: .entrance) ?? ""
        self.comment = try values.decodeIfPresent(String.self, forKey: .comment) ?? ""
        if let dateString = try values.decodeIfPresent(String.self, forKey: .lastUpdateDate) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            if let date = dateFormatter.date(from: dateString) {
                self.lastUpdateDate = date
            } else {
                self.lastUpdateDate = Date()
            }
        } else {
            self.lastUpdateDate = Date()
        }
    }
    
    var isStreetAndHouseFill: Bool {
        house != "" && street != ""
    }
    
    init() {
        self.city = ""
        self.street = ""
        self.house = ""
        self.floor = ""
        self.apartmentNumber = ""
        self.intercom = ""
        self.entrance = ""
        self.comment = ""
    }
    
    init(id: Int? = nil, city: String, street: String, house: String, floor: String, apartmentNumber: String, intercom: String, entrance: String, comment: String, lastUpdateDate: Date = Date.now) {
        self.city = city
        self.street = street
        self.house = house
        self.floor = floor
        self.apartmentNumber = apartmentNumber
        self.intercom = intercom
        self.entrance = entrance
        self.comment = comment
        self.lastUpdateDate = lastUpdateDate
    }
    
    func changeStreetAndHouse(city: String, street: String, house: String) -> Address {
        Address(id: self.id, city: city, street: street, house: house, floor: self.floor, apartmentNumber: self.apartmentNumber, intercom: self.intercom, entrance: self.entrance, comment: self.comment, lastUpdateDate: self.lastUpdateDate)
    }
    
    func changeID(_ id: Int?) -> Address {
        Address(id: id, city: self.city, street: self.street, house: self.house, floor: self.floor, apartmentNumber: self.apartmentNumber, intercom: self.intercom, entrance: self.entrance, comment: self.comment, lastUpdateDate: self.lastUpdateDate)
    }
    
    func convertToString() -> String {
        "\(street) \(house)"
    }
    
    func isEmpty() -> Bool {
        street.isEmpty || house.isEmpty
    }
}

struct AddAddressResponse: Codable {
    let message: String
    let addressId: Int
}

struct AddressResponse: Codable {
    let addresses: [Address]
}
