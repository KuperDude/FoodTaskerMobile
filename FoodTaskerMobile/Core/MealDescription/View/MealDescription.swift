//
//  RestaurantMealDetails.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 12.12.2022.
//

import SwiftUI

struct MealDescription: View {
    @ObservedObject var mainVM: MainViewModel
    var namespace: Namespace.ID
    var meal: Meal
    @Binding var orderDetails: OrderDetails
    
    init(mainVM: MainViewModel, orderDetails: Binding<OrderDetails>, namespace: Namespace.ID) {
        self._mainVM = ObservedObject(initialValue: mainVM)
        self.meal = orderDetails.meal.wrappedValue
        self._orderDetails = orderDetails
        self.namespace = namespace
    }
    
    @State private var showDescription = false
    
    typealias MatchedGeometryId = MealCell.MatchedGeometryId
    
    var body: some View {
        VStack {
            ScrollView {
                mealImage
                
                shortDescription
                
                quantity
                
                price
                
                Spacer()
                
            }
            .padding()
            .scrollIndicators(.hidden)
            
            addInCartButton
        }
    }
}

struct MealDescription_Previews: PreviewProvider {
    @Namespace static var namespace
    @StateObject static var mainVM = MainViewModel()
    static var previews: some View {
        MealDescription(mainVM: mainVM, orderDetails: .constant(OrderDetails(meal: Meal(id: 1, name: "Burger", shortDescription: "Description", image: "", price: 12.0, category: Category(id: 1, name: "Lol")), quantity: 1, id: UUID())), namespace: namespace)
    }
}

extension MealDescription {
    var mealImage: some View {
        ImageLoaderView(urlString: meal.image, resizingMode: .fit)
            .frame(maxWidth: .infinity)
            .aspectRatio(1/1, contentMode: .fill)
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.theme.background)
                    .shadow(
                        color: Color.theme.accent.opacity(0.15),
                        radius: 5, x: 0, y: 0)
            }
            .padding(.bottom, 5)
            .matchedGeometryEffect(id: MatchedGeometryId.image.rawValue + String(meal.id), in: namespace)
    }
    
    var shortDescription: some View {
        Text(meal.shortDescription)
            .frame(maxWidth: .infinity, alignment: .leading)
            .font(.system(size: 16))
            .fontWeight(.medium)
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
            .matchedGeometryEffect(id: MatchedGeometryId.description.rawValue + String(meal.id), in: namespace)
            .onTapGesture {
                showDescription = true
            }
    }
    
    var quantity: some View {
        HStack {
            Text("Колличество:")
                .font(.headline)
                .fontWidth(.compressed)
                .foregroundColor(.theme.accent)
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.theme.background)
                        .frame(height: 55)
                        .shadow(
                            color: Color.theme.accent.opacity(0.15),
                            radius: 5, x: 0, y: 0)
                }
            
            stepperQuantity
            
        }
        .font(.system(size: 20))
        .padding(.bottom, 5)
    }
    
    var price: some View {
        HStack {
            Text("Цена:")
                .font(.headline)
                .fontWidth(.compressed)
                .foregroundColor(.theme.accent)
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.theme.background)
                        .frame(height: 55)
                        .shadow(
                            color: Color.theme.accent.opacity(0.15),
                            radius: 5, x: 0, y: 0)
                }
            
            Text((meal.price * Float(orderDetails.quantity)).asCurrencyWith2Decimals())
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(.theme.green)
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.theme.background)
                        .frame(height: 55)
                        .shadow(
                            color: Color.theme.accent.opacity(0.15),
                            radius: 5, x: 0, y: 0)
                }
                .matchedGeometryEffect(id: MatchedGeometryId.cost.rawValue + String(meal.id), in: namespace)
        }
        .font(.system(size: 20))
        .padding(.bottom, 5)
    }
    
    var stepperQuantity: some View {
        HStack {
            Button {
                if orderDetails.quantity >= 2 {
                    orderDetails.quantity -= 1
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
                if orderDetails.quantity < 99 {
                    orderDetails.quantity += 1
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
                .frame(height: 55)
                .shadow(
                    color: Color.theme.accent.opacity(0.15),
                    radius: 5, x: 0, y: 0)
            
        }
    }
    
    var addInCartButton: some View {
        ZStack {

            Button {
                orderDetails.quantity += 1
            } label: {
                Text("Добавить в карзину")
                    .font(.headline)
                    .fontWidth(.compressed)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .foregroundColor(.theme.accent)
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.theme.green.opacity(0.5))
                            .shadow(
                                color: Color.theme.accent.opacity(0.15),
                                radius: 5, x: 0, y: 0)
                    }
                    .onTapGesture {
                        withAnimation(.easeIn) {
                            
                            if let index = mainVM.order.firstIndex(where: { $0 == orderDetails }) {
                                mainVM.changeQuantity(at: index, quantity: mainVM.order[index].quantity + orderDetails.quantity)
                            } else {
                                mainVM.order.append(orderDetails)
                            }
                            
                            mainVM.animateStatus = .burger
                        }
                    }
            }
        }
    }
}

