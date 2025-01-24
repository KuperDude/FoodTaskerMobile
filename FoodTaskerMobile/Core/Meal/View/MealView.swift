//
//  RestaurantView.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 08.12.2022.
//

import SwiftUI
import SwiftfulUI

struct MealView: View {
    @ObservedObject var mainVM: MainViewModel
    
    @State private var selectedIdMeal: Int?
    
    @StateObject var vm = MealViewModel()

    @Namespace var namespace
    
    @State private var isNeedToScrollToSelectedSection = true
    @State private var isScrolling = false
    
    var body: some View {
        ZStack(alignment: .top) {
            // background
            Color.theme.background
                .ignoresSafeArea()
            
            // content
            VStack {
                //topSector
                
                if mainVM.animateStatus.getChevronIdOrMinusOne == -1 && mainVM.currentCategory == .menu {
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
                        .opacity(mainVM.animateStatus.getChevronIdOrMinusOne != -1 ? 0 : 1)
                }
                
                if mainVM.animateStatus == .burger || mainVM.animateStatus == .cross {
                    mealsAndMealDetail
                }
                
                Spacer()
            }
            .ignoresSafeArea(edges: .bottom)
            .padding(.top, mainVM.animateStatus.getChevronIdOrMinusOne != -1 ? 0 : 50)
            
            topSector
        }
    }
}

struct RestaurantView_Previews: PreviewProvider {
    @StateObject static var mainVM = MainViewModel()
    static var previews: some View {
        MealView(mainVM: mainVM)
    }
}

extension MealView {
    var topSector: some View {
        HStack {
            MenuButtonView(mainVM: mainVM)
            
            Spacer()
            
            iconCart
                .overlay(content: {
                    if mainVM.order.quantity() > 0 {
                        Badge(count: mainVM.order.quantity())
                    }
                })
                .onTapGesture {
                    mainVM.animateStatus = .burger
                    mainVM.currentCategory = .cart
                }
        }
        .frame(height: 50)
        .background(.clear)
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
                if isNeedToScrollToSelectedSection {
                    isScrolling = true
                    withAnimation {
                        proxy.scrollTo(selected, anchor: .top)
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        isScrolling = false
                    }
                } else {
                    isNeedToScrollToSelectedSection = true
                }
            }
            .onAppear {
                guard let selectedIdMeal = selectedIdMeal else { return }
                
                isScrolling = true
                
                proxy.scrollTo(selectedIdMeal, anchor: .center)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    isScrolling = false
                }
                
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
            VStack {
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
            .readingFrame(coordinateSpace: .global) { frame in
                if !isScrolling && section != vm.selectedSection && ((frame.midY >= UIScreen.main.bounds.height/2 - 100 && frame.midY <= UIScreen.main.bounds.height/2 + 100) || (frame.minY >= 220 && frame.minY <= 260)) {
                    isNeedToScrollToSelectedSection = false
                    withAnimation {
                        vm.selectedSection = section
                    }
                }
            }
        }
    }
}
