//
//  HomeView.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 09.12.2022.
//

import SwiftUI

struct HomeView: View {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @State private var animateMenuButtonStatus: MenuButtonView.Status = .burger
    @State private var currentCategory: MenuCell.Category = .restaurants
    @Binding var isPresent: Bool
    
    var body: some View {
        ZStack {
            MenuView(currentCategory: $currentCategory)
            
            switch currentCategory {
            case .restaurants:
                RestaurantView(animateMenuButtonStatus: $animateMenuButtonStatus, currentCategory: $currentCategory)
                    .shadow(
                        color: Color.theme.accent.opacity(0.15),
                        radius: 10, x: 0, y: 0)
                    .offset(x: animateMenuButtonStatus == .cross(.leftMenu) ? (UIScreen.main.bounds.width / 1.5) : 0)
            case .cart:
                CartView(animateMenuButtonStatus: $animateMenuButtonStatus)
                    .shadow(
                        color: Color.theme.accent.opacity(0.15),
                        radius: 10, x: 0, y: 0)
                    .offset(x: animateMenuButtonStatus == .cross(.leftMenu) ? (UIScreen.main.bounds.width / 1.5) : 0)
            case .delivery:
                DeliveryView(animateMenuButtonStatus: $animateMenuButtonStatus)
                    .shadow(
                        color: Color.theme.accent.opacity(0.15),
                        radius: 10, x: 0, y: 0)
                    .offset(x: animateMenuButtonStatus == .cross(.leftMenu) ? (UIScreen.main.bounds.width / 1.5) : 0)
            case .logout:
                LoginView(appDelegate: appDelegate)
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(isPresent: .constant(false))
    }
}
