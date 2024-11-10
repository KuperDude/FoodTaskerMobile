//
//  MealDetail.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 10.04.2023.
//

import SwiftUI

struct MealDetail: View {
    
    var meal: Meal
    
    @ObservedObject var mainVM: MainViewModel
    var namespace: Namespace.ID
    @State private var data = ["Описание", "Состав"]
    @State var selected: String? = "Описание"
    
    @State var orderDetails: OrderDetails
    
    init(meal: Meal, mainVM: MainViewModel, namespace: Namespace.ID) {
        self.meal = meal
        self.mainVM = mainVM
        self.namespace = namespace
        self._orderDetails = State(initialValue: OrderDetails(meal: meal, ingredients: [], quantity: 1, id: UUID()))
    }
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(spacing: 8) {
                
                MealDetailHeader(title: meal.name, subtitle: "", imageName: meal.image)
                    .aspectRatio(1/1, contentMode: .fit)
                
                HPicker(data: $data, selected: $selected)
                    .frame(height: 40)
                
                if selected == "Описание" {
                    MealDescription(mainVM: mainVM, orderDetails: $orderDetails, namespace: namespace)
                        .transition(.move(edge: .leading))
                } else {
                    CompositionView(mainVM: mainVM, mealId: meal.id, ingredients: orderDetails.ingredients)
                        .transition(.move(edge: .leading))
                        .onPreferenceChange(IngPreferenceKey.self) { ingredients in
                            orderDetails.ingredients = ingredients
                        }
                }
                
            }
            .padding()
        }
        .scrollIndicators(.hidden)
    }
}

struct MealDetail_Previews: PreviewProvider {
    @StateObject static var mainVM = MainViewModel()
    @Namespace static var namespace
    static var previews: some View {
        MealDetail(meal: Meal(id: 1, name: "Burger", shortDescription: "Description", image: "", price: 12.0, category: Category(id: 1, name: "Lol")), mainVM: mainVM, namespace: namespace)
    }
}
