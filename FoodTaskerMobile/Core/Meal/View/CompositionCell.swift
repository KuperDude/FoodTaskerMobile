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
    
    @ObservedObject var vm: CompositionCellViewModel
    
    init(ingredient: Binding<Ingredient>) {
        self._ingredient = ingredient
        self._isCheck = ingredient.isAdd
        
        self._vm = ObservedObject(initialValue: CompositionCellViewModel(ingredient: ingredient.wrappedValue))
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.theme.background)
                .shadow(
                    color: Color.theme.accent.opacity(0.15),
                    radius: 5, x: 0, y: 0)
            
            HStack {
                if let image = vm.image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                } else if vm.isLoading {
                    ProgressView()
                        .frame(width: 60, height: 60)
                } else {
                    Image("blank_food")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                }
                
                
                Text(ingredient.name)
                    .font(.title)
                    .fontWidth(.compressed)
                
                Spacer()
                
                CheckButton(isCheck: $isCheck) {
                    //ingredient = ingredient.changeStatus()
                }
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
