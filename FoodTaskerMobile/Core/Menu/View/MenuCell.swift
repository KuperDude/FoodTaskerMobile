//
//  HomeCell.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 08.12.2022.
//

import SwiftUI

struct MenuCell: View {
    
    var category: Category
    
    var body: some View {

        HStack(spacing: 20) {
            Image(category.iconName)
                .renderingMode(.template)
                .resizable()
                .frame(width: 40, height: 40)
                .foregroundColor(.theme.secondaryText)
            
            Text(category.text)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.theme.secondaryText)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
}

struct MenuCell_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            ForEach(MenuCell.Category.allCases) { category in
                Divider()
                MenuCell(category: category)
            }
        }
    }
}

// MARK: - Category
extension MenuCell {
    enum Category: Int, CaseIterable, Identifiable {
        case restaurants
        case cart
        case delivery
        case logout 
        
        var id: Int {
            self.rawValue
        }
        
        var iconName: String {
            switch self {
            case .restaurants: return "icon_restaurants"
            case .cart: return "icon_cart"
            case .delivery: return "icon_delivery"
            case .logout: return "icon_logout"
            }
            
        }
        
        var text: String {
            switch self {
            case .restaurants: return "RESTAURANTS"
            case .cart: return "CART"
            case .delivery: return "DELIVERY"
            case .logout: return "LOGOUT"
            }
        }
    }
}


