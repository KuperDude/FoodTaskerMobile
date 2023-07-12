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
    @ObservedObject var vm: MealCellViewModel
    
    init(mainVM: MainViewModel, orderDetails: Binding<OrderDetails>, namespace: Namespace.ID) {
        self._mainVM = ObservedObject(initialValue: mainVM)
        self.meal = orderDetails.meal.wrappedValue
        self._orderDetails = orderDetails
        self.namespace = namespace
        self._vm = ObservedObject(initialValue: MealCellViewModel(meal: meal))
    }
    
    @State private var showDescription = false
    
    typealias MatchedGeometryId = MealCell.MatchedGeometryId
    
    var body: some View {
        ZStack {
            VStack {

//                    if let image = vm.image {
                    Image(uiImage: vm.image ?? UIImage())
                            .resizable()
                            .frame(maxWidth: .infinity)
                            .frame(height: 200)
                            .padding()
                            .background {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.theme.background)
                                    .shadow(
                                        color: Color.theme.accent.opacity(0.15),
                                        radius: 5, x: 0, y: 0)
                            }
                            .overlay(content: {
                                if vm.isLoading {
                                    ProgressView()
                                }
                            })
                            .padding(.bottom, 5)
                            .matchedGeometryEffect(id: MatchedGeometryId.image.rawValue + String(meal.id), in: namespace)
                            
//                    } else if vm.isLoading {
//                        ProgressView()
//                            .frame(maxWidth: .infinity)
//                            .frame(height: 200)
//                            .padding()
//                            .background {
//                                RoundedRectangle(cornerRadius: 10)
//                                    .fill(Color.theme.background)
//                                    .shadow(
//                                        color: Color.theme.accent.opacity(0.15),
//                                        radius: 5, x: 0, y: 0)
//                            }
//                            .padding(.bottom, 5)
//                    } else {
//                        Image("blank_food")
//                            .resizable()
//                            .frame(maxWidth: .infinity)
//                            .frame(height: 200)
//                            .padding()
//                            .background {
//                                RoundedRectangle(cornerRadius: 10)
//                                    .fill(Color.theme.background)
//                                    .shadow(
//                                        color: Color.theme.accent.opacity(0.15),
//                                        radius: 5, x: 0, y: 0)
//                            }
//                            .padding(.bottom, 5)
//                    }
                
                
                
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
                
                HStack {
                    Text("Quantity:")
                        .foregroundColor(.theme.accent)
                        .padding()
                        .background {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.theme.background)
                                .shadow(
                                    color: Color.theme.accent.opacity(0.15),
                                    radius: 5, x: 0, y: 0)
                        }
                    HStack {
                        Button {
                            if orderDetails.quantity >= 2 {
                                orderDetails.quantity -= 1
                            }
                        } label: {
                            Text("-")
                                .foregroundColor(.theme.accent)
                                .aspectRatio(1/1, contentMode: .fill)
                                .padding()
                                .background {
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.theme.background)
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
                                .foregroundColor(.theme.accent)
                                .aspectRatio(1/1, contentMode: .fill)
                                .padding()
                                .background {
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.theme.background)
                                        .shadow(
                                            color: Color.theme.accent.opacity(0.15),
                                            radius: 5, x: 0, y: 0)
                                        .padding(5)
                                }
                        }
                    }
                    .background {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.theme.background)
                            .shadow(
                                color: Color.theme.accent.opacity(0.15),
                                radius: 5, x: 0, y: 0)
                        
                    }
                    
                }
                .font(.system(size: 20))
                .padding(.bottom, 5)
                
                
                
                HStack {
                    Text("Price:")
                        .foregroundColor(.theme.accent)
                        .padding()
                        .background {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.theme.background)
                                .shadow(
                                    color: Color.theme.accent.opacity(0.15),
                                    radius: 5, x: 0, y: 0)
                        }
                    Text("$\((meal.price * Float(orderDetails.quantity)).asNumberString())")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(.theme.green)
                        .padding()
                        .background {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.theme.background)
                                .shadow(
                                    color: Color.theme.accent.opacity(0.15),
                                    radius: 5, x: 0, y: 0)
                        }
                        .matchedGeometryEffect(id: MatchedGeometryId.cost.rawValue + String(meal.id), in: namespace)
                }
                .font(.system(size: 20))
                .padding(.bottom, 5)
                
                Button {
                    orderDetails.quantity += 1
                } label: {
                    Text("Add To Cart")
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
                
                
                Spacer()
                
            }
            .padding()
        }
    }
}

struct MealDescription_Previews: PreviewProvider {
    @Namespace static var namespace
//    static var mainVM = MainViewModel()
    @StateObject static var mainVM = MainViewModel()
    static var previews: some View {
        MealDescription(mainVM: mainVM, orderDetails: .constant(OrderDetails(meal: Meal(id: 1, name: "Burger", shortDescription: "Description", image: "", price: 12.0, category: Category(id: 1, name: "Lol")), quantity: 1, id: UUID())), namespace: namespace)
//            .environmentObject(mainVM)
    }
}

