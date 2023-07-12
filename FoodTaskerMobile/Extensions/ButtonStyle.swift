//
//  ButtonStyle.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 10.06.2023.
//

import SwiftUI

struct NoAnim: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
    }
}
