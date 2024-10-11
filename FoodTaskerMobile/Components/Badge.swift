//
//  Badge.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 28.01.2023.
//

import SwiftUI

struct Badge: View {
    let count: Int

    var body: some View {
        ZStack(alignment: .topTrailing) {
            Color.clear
            Text(String(count))
                .font(.system(size: 16))
                .padding(5)
                .background(Color.red)
                .clipShape(Circle())
                
        }
    }
}
