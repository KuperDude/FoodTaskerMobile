//
//  CompositionView.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 10.04.2023.
//

import SwiftUI

struct CompositionCell: View {
    @Binding var ingredient: Ingredient
    @Binding var isCheck: Bool
        
    init(ingredient: Binding<Ingredient>) {
        self._ingredient = ingredient
        self._isCheck = ingredient.isAdd
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.theme.background)
                .shadow(
                    color: Color.theme.accent.opacity(0.15),
                    radius: 5, x: 0, y: 0)
            
            HStack {
                ImageLoaderView(urlString: ingredient.image, resizingMode: .fit)
                    .frame(width: 60, height: 60)
                    .scaledToFill()
                
                
                Text(ingredient.name)
                    .font(.title)
                    .fontWidth(.compressed)
                
                Spacer()
                
                CheckButton(isCheck: $isCheck) {}
                    .scaleEffect(0.4)
            }
            .padding(.leading)
        }
    }
}

struct CompositionCell_Previews: PreviewProvider {
    static var previews: some View {
        CompositionCell(ingredient: .constant(Ingredient(id: 12, name: "Solt", image: "", isAdd: true)))
            .frame(height: 80)
            .padding()
    }
}
