//
//  Float.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 02.01.2023.
//

import Foundation

extension Float {
    /// Convertes a Float into a String representation
    /// ```
    /// Convert 1.23456 to "1.23"
    /// ```
    func asNumberString() -> String {
        return String(format: "%.2f", self)
    }
}
