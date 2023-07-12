//
//  RestaurantView.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 08.12.2022.
//

import SwiftUI

struct RestaurantView: View {
    @ObservedObject var mainVM: MainViewModel
    
    @State private var pickerSection = 0
    
    @StateObject var vm = RestaurantViewModel()

    @Namespace var namespace
    
    typealias MatchedGeometryId = MealCell.MatchedGeometryId
    
    var body: some View {
        ZStack {
            // background
            Color.theme.background
                .ignoresSafeArea()
            
            // content
            VStack {
                topSector
                
                if mainVM.animateStatus.getCrossIdOrMinusOne == -1 {
                    SearchBarView(searchText: $vm.searchText)
                }
                
                if mainVM.animateStatus.getCrossIdOrMinusOne != -1 {
                    if let meal = vm.getMeal(at: mainVM.animateStatus.getCrossIdOrMinusOne) {
                        MealDetail(meal: meal, mainVM: mainVM, namespace: namespace)
                            .transition(.move(edge: .trailing))
                    }
                } else {
                    HPicker(data: $vm.sections, selected: $vm.selectedSection)
                        .frame(height: 40)
                }
                
                if mainVM.animateStatus == .burger || mainVM.animateStatus == .cross {
//                    restaurants
                    mealsAndMealDetail
                }
                
                Spacer()
            }
            .ignoresSafeArea(edges: .bottom)
        }
    }
}

struct RestaurantView_Previews: PreviewProvider {
//    static var mainVM = MainViewModel()
    @StateObject static var mainVM = MainViewModel()
    static var previews: some View {
        RestaurantView(mainVM: mainVM)
//            .environmentObject(mainVM)
    }
}

extension RestaurantView {
    var topSector: some View {
        HStack {
            MenuButtonView(mainVM: mainVM) {
//                if mainVM.animateStatus == .chevron {
//                    vm.selectedRestaurantId = nil
//                }
            }
            
            Spacer()
            
            if mainVM.animateStatus.getCrossIdOrMinusOne != -1 {
                title
            }
            
            
            iconCart
                .overlay(content: {
                    Badge(count: mainVM.order.quantity())
                })
                .onTapGesture {
                    mainVM.animateStatus = .burger
                    mainVM.currentCategory = .cart
                }
        }
        .frame(height: 50)
    }
    
    var mealsAndMealDetail: some View {
        ScrollViewReader { geometry in
            ScrollView(showsIndicators: false) {
                if !vm.mealsIsLoading {
                    ForEach(vm.sections, id: \.self) { section in
                        Text(section)
                            .font(.title)
                            .fontWidth(.condensed)
                            .id(section)
                            .frame(alignment: .leading)
                        
                        ForEach(vm.getMeals(at: section)) { meal in
                            if meal.id != mainVM.animateStatus.getCrossIdOrMinusOne {
                                MealCell(namespace: namespace, meal: meal)
                                    .onTapGesture {
                                        withAnimation(.easeIn) {
                                            mainVM.animateStatus = .chevron(.mealDetails(id: meal.id))
                                            geometry.scrollTo(meal.id, anchor: .top)
                                        }
                                    }
                                    .padding(15)
                                    .padding(.bottom, 5)
                                    .id(meal.id)
                            } else {
//                                MealDetails(mainVM: mainVM, namespace: namespace, meal: meal)
//                                    .id(meal.id)
                            }
                        }
                    }
//                    ForEach(vm.meals) { meal in
//                        Text(meal.category.name)
//                            .font(.title)
//                            .fontWidth(.condensed)
//                            .id(meal.category.name)
//
//                        if meal.id != mainVM.animateStatus.getCrossIdOrMinusOne {
//                            MealCell(namespace: namespace, meal: meal)
//                                .onTapGesture {
//                                    withAnimation(.easeIn) {
//                                        mainVM.animateStatus = .cross(.mealDetails(id: meal.id))
//                                        geometry.scrollTo(meal.id, anchor: .top)
//                                    }
//                                }
//                                .padding(15)
//                                .padding(.bottom, 5)
//                                .id(meal.id)
//                        } else {
//                            MealDetails(mainVM: mainVM, namespace: namespace, meal: meal)
//                                .id(meal.id)
//                        }
//                    }
                } else {
                    ForEach(0..<6) { _ in
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.theme.background)
                                .shadow(
                                    color: Color.theme.accent.opacity(0.15),
                                    radius: 5, x: 0, y: 0)
                            
                            ProgressView()
                                
                        }
                        .frame(height: 160)
                        .padding(15)
                        .padding(.bottom, 5)
                    }
                }
            }
            .onChange(of: vm.selectedSection) { selected in
                withAnimation {
                    geometry.scrollTo(selected, anchor: .top)
                }
            }
        }
        .transition(.move(edge: .leading))
    }
    
    var restaurants: some View {
        ScrollView(showsIndicators: false) {
            ForEach(vm.restaurants) { restaurant in
                RestaurantCell(restaurant: restaurant)
                    .onTapGesture {
                        withAnimation(.spring()) {
                            mainVM.selectedRestaurantId = restaurant.id
                            vm.selectedRestaurantId = restaurant.id
                            //mainVM.animateStatus = .chevron
                        }
                    }
                    .padding(5)
                    .padding(.bottom, 5)
            }
        }
        .transition(.move(edge: .leading))
    }
    
    var title: some View {
        Text(vm.getRestaurantName())
            .frame(maxWidth: .infinity, alignment: .center)
            .font(.system(size: 30))
            .fontWeight(.semibold)
            .foregroundColor(.theme.accent)
    }
    
    var iconCart: some View {
        Image("icon_cart")
            .resizable()
            .renderingMode(.template)
            .foregroundColor(.theme.accent)
            .frame(width: 35, height: 35)
            .padding()
    }
}
