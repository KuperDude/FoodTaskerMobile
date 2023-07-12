//
//  RestaurantCell.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 08.12.2022.
//

import SwiftUI

struct RestaurantCell: View {
    
    var restaurant: Restaurant
    
    @ObservedObject var vm: RestaurantCellViewModel
    
    init(restaurant: Restaurant) {
        self.restaurant = restaurant
        self._vm = ObservedObject(initialValue: RestaurantCellViewModel(restaurant: restaurant))
    }
    
    var body: some View {
        ZStack {
            
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.theme.background)
                .shadow(
                    color: Color.theme.accent.opacity(0.15),
                    radius: 5, x: 0, y: 0)
                .overlay {
                    if let image = vm.image {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(height: 240)
                    } else if vm.isLoading {
                        ProgressView()
                    } else {
                        Image("blank_food")
                            .resizable()
                            .scaledToFill()
                            .frame(height: 240)
                    }
                        
                }
                .clipShape(RoundedRectangle(cornerRadius: 10))
            
            VStack(spacing: 8) {
                
                Text(restaurant.name)
                    .padding(5)
                    .background {
                        Rectangle()
                            .cornerRadius(10, corners: [.bottomRight, .topLeft])
                            .foregroundColor(Color.theme.red)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.system(size: 20))
                    .fontWeight(.semibold)
                    .foregroundColor(.theme.accent)
                    
                
                Spacer()
                    
                
//                Text(restaurant.address)
//                    .frame(maxWidth: .infinity, alignment: .leading)
//                    .padding(.leading, 20)
//                    .font(.system(size: 16))
//                    .fontWeight(.light)
//                    .foregroundColor(.theme.secondaryText)
                
            }
                
        }
        .frame(height: 240)
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 5)
    }
}

struct RestaurantCell_Previews: PreviewProvider {
    static var previews: some View {
        RestaurantCell(restaurant: Restaurant(id: 1, name: "Good", address: "l,zwl,wzl", logo: ""))
    }
}
