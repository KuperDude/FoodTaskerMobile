//
//  MealDetail.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 10.04.2023.
//

import SwiftUI
import SwiftfulUI

struct MealDetail: View {
    
    enum Menu: String, CaseIterable {
        case description = "Описание"
        case composition = "Состав"
    }
    
    var meal: Meal
    
    @ObservedObject var mainVM: MainViewModel
    var namespace: Namespace.ID
    @State private var data = Menu.allCases.map { $0.rawValue }
    @State var selected: String? = Menu.description.rawValue
    
    @State var showHeader: Bool = false
    
    @State var orderDetails: OrderDetails
    
    init(meal: Meal, mainVM: MainViewModel, namespace: Namespace.ID) {
        self.meal = meal
        self.mainVM = mainVM
        self.namespace = namespace
        self._orderDetails = State(initialValue: OrderDetails(meal: meal, ingredients: [], quantity: 1, id: UUID()))
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            ScrollView(.vertical) {
                VStack(spacing: 8) {
                    
                    MealDetailHeader(title: meal.name, subtitle: "", imageName: meal.image)
                        .aspectRatio(1/1, contentMode: .fit)
                        .readingFrame { frame in
                            showHeader = frame.maxY < 100
                        }
                    
                    HPicker(data: $data, selected: $selected)
                        .foregroundStyle(Color.theme.accent)
                        .frame(height: 40)
                    
                    ZStack {
                        MealDescription(mainVM: mainVM, orderDetails: $orderDetails, namespace: namespace)
                            .offset(x: selected == Menu.description.rawValue ? 0 : -UIScreen.main.bounds.width)
                        
                        CompositionView(mainVM: mainVM, mealId: meal.id, ingredients: orderDetails.ingredients)
                            .onPreferenceChange(IngPreferenceKey.self) { ingredients in
                                orderDetails.ingredients = ingredients
                            }
                            .offset(x: selected == Menu.composition.rawValue ? 0 : UIScreen.main.bounds.width)
                    }
                    
                }
                .padding()
            }
            .scrollIndicators(.hidden)
            
            header
        }
    }
}

struct MealDetail_Previews: PreviewProvider {
    @StateObject static var mainVM = MainViewModel()
    @Namespace static var namespace
    static var previews: some View {
        MealDetail(meal: Meal(id: 1, name: "Burger", shortDescription: "Description", image: "", price: 12.0, category: Category(id: 1, name: "Lol")), mainVM: mainVM, namespace: namespace)
    }
}

extension MealDetail {
    
    private var header: some View {
        Text(meal.name)
            .frame(maxWidth: .infinity)
            .font(.title)
            .fontWidth(.compressed)
            .padding(.vertical)
            .background(Color.theme.background)
            .opacity(showHeader ? 1 : 0)
            .frame(maxHeight: .infinity, alignment: .top)
            .foregroundStyle(Color.theme.accent)
            .offset(y: showHeader ? 0 : -32)
            .animation(.smooth(duration: 0.2), value: showHeader)
    }
}
