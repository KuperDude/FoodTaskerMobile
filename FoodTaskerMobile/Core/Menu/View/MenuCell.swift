//
//  HomeCell.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 08.12.2022.
//

import SwiftUI

struct MenuCell: View {
    
    var category: MainViewModel.Category
    
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
            ForEach(MainViewModel.Category.allCases) { category in
                Divider()
                MenuCell(category: category)
            }
        }
    }
}


