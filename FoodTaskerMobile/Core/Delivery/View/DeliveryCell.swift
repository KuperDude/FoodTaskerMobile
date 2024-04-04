//
//  DeliveryCell.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 17.12.2022.
//

import SwiftUI

struct DeliveryCell: View {
    var text: String = ""
    var check: Bool
    var body: some View {
        HStack(spacing: 20) {
            Image(systemName: "checkmark.circle.fill")
                .resizable()
                .frame(width: 30, height: 30)
                .foregroundColor(check ? .theme.green : .black)
            
            Text(text)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.theme.accent)
            
            Spacer()
        }
    }
}

struct DeliveryCell_Previews: PreviewProvider {
    static var previews: some View {
        DeliveryCell(check: true)
    }
}
