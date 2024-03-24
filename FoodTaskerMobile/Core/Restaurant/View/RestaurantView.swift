//
//  RestaurantView.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 08.12.2022.
//

import SwiftUI

struct RestaurantView: View {
    @ObservedObject var mainVM: MainViewModel
    
    @State private var selectedIdMeal: Int?
//    @State private var isNewSectionScroll: Bool = false
    
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
                
                if mainVM.animateStatus.getChevronIdOrMinusOne == -1 {
                    SearchBarView(searchText: $vm.searchText)
                }
                
                if mainVM.animateStatus.getChevronIdOrMinusOne != -1 {
                    if let meal = vm.getMeal(at: mainVM.animateStatus.getChevronIdOrMinusOne) {
                        MealDetail(meal: meal, mainVM: mainVM, namespace: namespace)
                            .transition(.move(edge: .trailing))
                    }
                } else {
                    HPicker(data: $vm.sections, selected: $vm.selectedSection)
                        .frame(height: 40)
                }
                
                if mainVM.animateStatus == .burger || mainVM.animateStatus == .cross {
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
            MenuButtonView(mainVM: mainVM) {}
            
            Spacer()
            
//            if mainVM.animateStatus.getChevronIdOrMinusOne != -1 {
//                title
//            }
            
            iconCart
                .overlay(content: {
                    if  mainVM.order.quantity() > 0 {
                        Badge(count: mainVM.order.quantity())
                    }
                })
                .onTapGesture {
                    mainVM.animateStatus = .burger
                    mainVM.currentCategory = .cart
                }
        }
        .frame(height: 50)
    }
    
    var mealsAndMealDetail: some View {
        ScrollViewReader { proxy in
            ScrollView(showsIndicators: false) {
                if !vm.mealsIsLoading {
                    mealsContent
                } else {
                    loadingContent
                }
            }
            .onChange(of: vm.selectedSection) { selected in
//                if !isNewSectionScroll {
                    withAnimation {
                        proxy.scrollTo(selected, anchor: .top)
                    }
//                }
            }
            .onAppear {
                guard let selectedIdMeal = selectedIdMeal else { return }
                
                proxy.scrollTo(selectedIdMeal, anchor: .center)
                
                self.selectedIdMeal = nil
            }
        }
        .transition(.move(edge: .leading))
    }
    
    var iconCart: some View {
        Image("icon_cart")
            .resizable()
            .renderingMode(.template)
            .foregroundColor(.theme.accent)
            .frame(width: 35, height: 35)
            .padding()
    }
    
    var loadingContent: some View {
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
            .padding(.bottom, 7.5)
        }
    }
    
    var mealsContent: some View {
        ForEach(vm.sections, id: \.self) { section in
            Text(section)
                .frame(maxWidth: .infinity)
                .fontWidth(.compressed)
                .font(.title)
                .fontWidth(.condensed)
                .id(section)
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 0, content: {
                ForEach(vm.getMeals(at: section)) { meal in
                        MealCell(namespace: namespace, meal: meal, mainVM: mainVM)
                            .onTapGesture {
                                withAnimation(.easeIn) {
                                    mainVM.animateStatus = .chevron(.mealDetails(id: meal.id))
                                    selectedIdMeal = meal.id
                                }
                            }
                            .padding(.bottom, 5)
                            .id(meal.id)
                }
            })
            .padding(.horizontal, 5)
            
        }
    }
}
