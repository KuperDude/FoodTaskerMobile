//
//  MealCell.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 10.12.2022.
//

import SwiftUI

struct MealCell: View {
    var namespace: Namespace.ID
    var meal: Meal
        
    @ObservedObject var mainVM: MainViewModel
    @State private var orderDetails: OrderDetails
    
    init(namespace: Namespace.ID, meal: Meal, mainVM: MainViewModel) {
        self.namespace = namespace
        self.meal = meal
        self.mainVM = mainVM
        self._orderDetails = State(initialValue: mainVM.order.first(where: { $0.meal.id == meal.id }) ?? OrderDetails(meal: meal, ingredients: [], quantity: 0, id: UUID())) 
    }
    
    var body: some View {
        ZStack {
            //background
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.theme.background)
                .shadow(
                    color: Color.theme.accent.opacity(0.15),
                    radius: 5, x: 0, y: 0)
            
            
            // content
            VStack(alignment: .center) {
                
                mainContent
                
                Spacer()
                    
                if orderDetails.quantity == 0 {
                    mealQuantityEqualZero
                } else {
                    mealQuantityIsNotZero
                }
            }
            
            Spacer()
        }
    }
}

struct MealCell_Previews: PreviewProvider {
    @Namespace static var namespace
    static var previews: some View {
        MealCell(namespace: namespace, meal: Meal(id: 1, name: "Burger", shortDescription: "Description", image: "", price: 12.0, category: .init(id: 1, name: "")), mainVM: MainViewModel())
    }
}

extension MealCell {
    enum MatchedGeometryId: String, Identifiable {
        case title
        case description
        case image
        case cost
        case background
        
        var id: String {
            self.rawValue
        }
    }
}

extension MealCell {
    var mainContent: some View {
        VStack(alignment: .center) {
            ImageLoaderView(urlString: meal.image, resizingMode: .fit)
                .padding()
                .frame(maxWidth: .infinity)
                .aspectRatio(1/1, contentMode: .fit)
                .matchedGeometryEffect(id: MatchedGeometryId.image.rawValue + String(meal.id), in: namespace)
            
            
            Text(meal.name)
                .font(.system(size: 20))
                .fontWeight(.semibold)
                .foregroundColor(.theme.accent)
                .matchedGeometryEffect(id: MatchedGeometryId.title.rawValue + String(meal.id), in: namespace)
        }
    }
    
    var mealQuantityEqualZero: some View {
        HStack {
            Text(meal.price.asCurrencyWith2Decimals())
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.system(size: 18))
                .foregroundColor(.theme.green)
                .matchedGeometryEffect(id: MatchedGeometryId.cost.rawValue + String(meal.id), in: namespace)
            
            Button {
                withAnimation(.linear) {
                    orderDetails.quantity += 1
                    mainVM.order.append(orderDetails)
                }
            } label: {
                Text("+")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.theme.accent)
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(style: StrokeStyle(lineWidth: 3))
                            .frame(width: 35, height: 35)
                            .foregroundStyle(Color.accentColor)
                            .shadow(
                                color: Color.theme.accent.opacity(0.15),
                                radius: 5, x: 0, y: 0)
                            .padding(5)
                    }
            }
        }
        .padding()
    }
    
    var mealQuantityIsNotZero: some View {
        VStack {
            Text(meal.price.asCurrencyWith2Decimals())
                .font(.system(size: 12))
                .foregroundColor(.theme.secondaryText)
                .matchedGeometryEffect(id: MatchedGeometryId.cost.rawValue + String(meal.id), in: namespace)
            
            stepperQuantity
                
        }
    }
    
    var stepperQuantity: some View {
        HStack {
            Button {
                withAnimation(.linear) {
                    if orderDetails.quantity >= 2 {
                        
                        orderDetails.quantity -= 1
                        
                        if let index = mainVM.order.firstIndex(where: { $0 == orderDetails }) {
                            mainVM.changeQuantity(at: index, quantity: orderDetails.quantity)
                        }
                    } else {
                        orderDetails.quantity = 0
                        
                        guard let index = mainVM.order.firstIndex(where: { $0.id == orderDetails.id }) else { return }
                        
                        mainVM.order.remove(at: index)
                    }
                }
            } label: {
                Text("-")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.theme.accent)
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(style: StrokeStyle(lineWidth: 3))
                            .frame(width: 35, height: 35)
                            .foregroundStyle(Color.accentColor)
                            .shadow(
                                color: Color.theme.accent.opacity(0.15),
                                radius: 5, x: 0, y: 0)
                            .padding(5)
                    }
            }
            
            Text("\(orderDetails.quantity)")
                .frame(maxWidth: .infinity, alignment: .center)
                .foregroundColor(.theme.accent)
            
            Button {
                withAnimation(.linear) {
                    if orderDetails.quantity < 99 {
                        orderDetails.quantity += 1
                        
                        if let index = mainVM.order.firstIndex(where: { $0 == orderDetails }) {
                            mainVM.changeQuantity(at: index, quantity: orderDetails.quantity)
                        }
                    }
                }
            } label: {
                Text("+")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.theme.accent)
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(style: StrokeStyle(lineWidth: 3))
                            .frame(width: 35, height: 35)
                            .foregroundStyle(Color.accentColor)
                            .shadow(
                                color: Color.theme.accent.opacity(0.15),
                                radius: 5, x: 0, y: 0)
                            .padding(5)
                    }
            }
        }
        .padding(.horizontal, 5)
        .background {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.theme.background)
                .shadow(
                    color: Color.theme.accent.opacity(0.15),
                    radius: 5, x: 0, y: 0)
            
        }
        .padding()
    }
}
