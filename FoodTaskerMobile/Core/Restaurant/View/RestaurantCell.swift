//
//  RestaurantCell.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 08.12.2022.
//

import SwiftUI

struct RestaurantCell: View {
    var body: some View {
        ZStack {
            
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.theme.background)
                .shadow(
                    color: Color.theme.accent.opacity(0.15),
                    radius: 5, x: 0, y: 0)
            
            VStack(spacing: 8) {
                Image("blank_food")
                    .resizable()
                    .scaledToFill()
                    .frame(height: 160)
                    .clipped()
                    .background {
                        Color.theme.background
                    }
                    .padding(.horizontal, 10)
                    .padding(.top, 10)
                
                Text("Restaurant Name")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 20)
                    .font(.system(size: 20))
                    .fontWeight(.semibold)
                    .foregroundColor(.theme.accent)
                    
                
                Text("Location")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 20)
                    .font(.system(size: 16))
                    .fontWeight(.light)
                    .foregroundColor(.theme.secondaryText)
                
                Spacer()
                
            }
                
        }
        .frame(height: 240)
        .frame(maxWidth: .infinity)
    }
}

struct RestaurantCell_Previews: PreviewProvider {
    static var previews: some View {
        RestaurantCell()
    }
}
