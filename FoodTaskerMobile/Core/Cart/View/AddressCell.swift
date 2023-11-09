//
//  AdressCell.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 24.07.2023.
//

import SwiftUI

struct AddressCell: View {
    var number: Int
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Image(systemName: number == 2 ? "checkmark.circle.fill" : "circle")
                        .resizable()
                        .frame(width: 30, height: 30)
                        
                    Text("ул 40 лет Победы, 17Д")
                        .font(.title)
                        .fontWidth(.compressed)
                    
                    Spacer()
                    Image(systemName: "slider.horizontal.3")
                        .resizable()
                        .frame(width: 20, height: 20)
                        
                }
                .padding(.horizontal)
                .frame(height: 50)
                Divider()
            }
        }
    }
}

struct AdressCell_Previews: PreviewProvider {
    static var previews: some View {
        AddressCell(number: 123)
    }
}
