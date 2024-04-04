//
//  CompositionView.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 10.04.2023.
//

import SwiftUI

struct CompositionView: View {
    @ObservedObject var vm: CompositionViewModel
    
    init(mainVM: MainViewModel, mealId: Int, orderDetailsId: UUID? = nil, ingredients: [Ingredient]? = nil) {
        self.vm = CompositionViewModel(mainVM: mainVM, mealId: mealId, orderDetailsId: orderDetailsId, gotenIngredients: ingredients)
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                ForEach($vm.ingredients) { ingredient in
                    CompositionCell(ingredient: ingredient)
                        .padding(.horizontal)
                }
            }
        }
        .preference(key: IngPreferenceKey.self, value: vm.ingredients)
    }
}

struct IngPreferenceKey: PreferenceKey {
    static var defaultValue: [Ingredient] = []
    
    static func reduce(value: inout [Ingredient], nextValue: () -> [Ingredient]) {
        value = nextValue()
    }
}

struct CompositionView_Previews: PreviewProvider {
    static var previews: some View {
        CompositionView(mainVM: MainViewModel(), mealId: 1, orderDetailsId: UUID())
    }
}
