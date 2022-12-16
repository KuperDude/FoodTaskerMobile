//
//  RestaurantView.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 08.12.2022.
//

import SwiftUI

struct RestaurantView: View {
    
    @State private var text: String = ""
    @Binding var animateMenuButtonStatus: MenuButtonView.Status
    @Binding var currentCategory: MenuCell.Category
    @Namespace var namespace
    
    typealias MatchedGeometryId = RestaurantMealCell.MatchedGeometryId
    
    var body: some View {
        ZStack {
            // background
            Color.theme.background
                .ignoresSafeArea()
            
            // content
            VStack {
                topSector
                
                if animateMenuButtonStatus.getCrossIdOrMinusOne == -1 {
                    SearchBarView(searchText: $text)
                }
                
                if animateMenuButtonStatus == .chevron || animateMenuButtonStatus.getCrossIdOrMinusOne != -1 {
                    mealsAndMealDetail
                }
                
                if animateMenuButtonStatus == .burger || animateMenuButtonStatus == .cross(.leftMenu) {
                    restaurants
                }
                
                Spacer()
            }
            .ignoresSafeArea(edges: .bottom)
        }
    }
}

struct RestaurantView_Previews: PreviewProvider {
    static var previews: some View {
        RestaurantView(animateMenuButtonStatus: .constant(.burger), currentCategory: .constant(.restaurants))
    }
}

extension RestaurantView {
    var topSector: some View {
        HStack {
            MenuButtonView(animateStatus: $animateMenuButtonStatus) {}
            
            Spacer()
            
            if animateMenuButtonStatus.getCrossIdOrMinusOne != -1 {
                title
            }
            
            iconCart
                .onTapGesture {
                    animateMenuButtonStatus = .burger
                    currentCategory = .cart
                }
        }
    }
    
    var mealsAndMealDetail: some View {
        ScrollViewReader { geometry in
            ScrollView(showsIndicators: false) {
                ForEach(0..<3) { index in
                    if index != animateMenuButtonStatus.getCrossIdOrMinusOne {
                        RestaurantMealCell(namespace: namespace, id: index)
                            .onTapGesture {
                                withAnimation(.easeIn) {
                                    animateMenuButtonStatus = .cross(.mealDetails(id: index))
                                    geometry.scrollTo(index, anchor: .top)
                                }
                            }
                            .padding(15)
                            .padding(.bottom, 5)
                            .id(index)
                    } else {
                        RestaurantMealDetails(namespace: namespace, id: animateMenuButtonStatus.getCrossIdOrMinusOne)
                            .id(index)
                    }
                }
            }
        }
        .transition(.move(edge: .trailing))
    }
    
    var restaurants: some View {
        ScrollView(showsIndicators: false) {
            ForEach(0..<3) { _ in
                RestaurantCell()
                    .onTapGesture {
                        withAnimation(.spring()) {
                            animateMenuButtonStatus = .chevron
                        }
                    }
                    .padding(5)
                    .padding(.bottom, 5)
            }
        }
        .transition(.move(edge: .leading))
    }
    
    var title: some View {
        Text("Meal" + String(animateMenuButtonStatus.getCrossIdOrMinusOne))
            .frame(maxWidth: .infinity, alignment: .center)
            .font(.system(size: 30))
            .fontWeight(.semibold)
            .foregroundColor(.theme.accent)
            .matchedGeometryEffect(id: MatchedGeometryId.title.rawValue + String(animateMenuButtonStatus.getCrossIdOrMinusOne), in: namespace)
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
