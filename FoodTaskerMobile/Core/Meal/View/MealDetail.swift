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
        VStack {
            Text(meal.name)
                .frame(maxWidth: .infinity, alignment: .center)
                .font(.system(size: 20))
                .fontWeight(.heavy)
                .foregroundColor(.theme.accent)
                .padding(.vertical, 10)
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.theme.background)
                        .shadow(
                            color: Color.theme.accent.opacity(0.15),
                            radius: 5, x: 0, y: 0)
                }
                .padding(.bottom, 5)
            
            HPicker(data: $data, selected: $selected)
                .frame(height: 40)
            
            if selected == "Описание" {
                MealDescription(mainVM: mainVM, orderDetails: $orderDetails, namespace: namespace)
                    .transition(.move(edge: .leading))
            } else {
                CompositionView(mainVM: mainVM, mealId: meal.id, ingredients: orderDetails.ingredients)
                    .transition(.move(edge: .trailing))
                    .onPreferenceChange(IngPreferenceKey.self) { ingredients in
                        orderDetails.ingredients = ingredients
                    }
            }
        }
        .padding()
    }
}

struct MealDetail_Previews: PreviewProvider {
    @StateObject static var mainVM = MainViewModel()
    @Namespace static var namespace
    static var previews: some View {
        MealDetail(meal: Meal(id: 1, name: "Burger", shortDescription: "Description", image: "", price: 12.0, category: Category(id: 1, name: "Lol")), mainVM: mainVM, namespace: namespace)
    }
}
