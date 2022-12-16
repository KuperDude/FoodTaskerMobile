//
//  CartCell.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 13.12.2022.
//

import SwiftUI

struct CartCell: View {
    var body: some View {
        HStack {
            Text("2")
                .foregroundColor(.theme.accent)
                .padding()
            
            Text("Meal")
                .foregroundColor(.theme.accent)
                .padding()
                .underline()
            Spacer()
            
            Text("$12")
                .font(.system(size: 18))
                .foregroundColor(.theme.green)
                .padding()
        }
    }
}

struct CartCell_Previews: PreviewProvider {
    static var previews: some View {
        CartCell()
    }
}
