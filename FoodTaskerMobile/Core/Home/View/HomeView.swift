//
//  HomeView.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 09.12.2022.
//

import SwiftUI

struct HomeView: View {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @ObservedObject var mainVM: MainViewModel
    
    var body: some View {
        ZStack {
            MenuView(mainVM: mainVM)
            
            switch mainVM.currentCategory {
            case .menu:
                RestaurantView(mainVM: mainVM)
                    .shadow(
                        color: Color.theme.accent.opacity(0.15),
                        radius: 10, x: 0, y: 0)
                    .offset(x: mainVM.animateStatus == .cross ? (UIScreen.main.bounds.width / 1.5) : 0)
            case .cart:
                CartView(mainVM: mainVM)
                    .shadow(
                        color: Color.theme.accent.opacity(0.15),
                        radius: 10, x: 0, y: 0)
                    .offset(x: mainVM.animateStatus == .cross ? (UIScreen.main.bounds.width / 1.5) : 0)
            case .delivery:
                DeliveryView(mainVM: mainVM)
                    .shadow(
                        color: Color.theme.accent.opacity(0.15),
                        radius: 10, x: 0, y: 0)
                    .offset(x: mainVM.animateStatus == .cross ? (UIScreen.main.bounds.width / 1.5) : 0)
            case .logout:
                LoginView(mainVM: mainVM)
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    @StateObject static var mainVM = MainViewModel()
    static var previews: some View {
        HomeView(mainVM: mainVM)
//            .environmentObject(mainVM)
    }
}
