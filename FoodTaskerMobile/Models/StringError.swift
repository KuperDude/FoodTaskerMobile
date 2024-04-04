//
//  ErrorString.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 04.04.2024.
//

import Foundation

struct StringError : LocalizedError {
    var description: String

    init(_ description: String)
    {
        self.description = description
    }
}
