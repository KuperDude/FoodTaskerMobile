//
//  HomeView.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 09.12.2022.
//

import SwiftUI

struct HomeView: View {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var mainVM: MainViewModel
    
    var body: some View {
        ZStack {
            MenuView(mainVM: mainVM)
            
            Group {
                switch mainVM.currentCategory {
                case .menu:
                    MealView(mainVM: mainVM)
                case .cart:
                    CartView(mainVM: mainVM)
                case .delivery:
                    DeliveryView(mainVM: mainVM)
                case .logout:
                    EmptyView()
                }
            }
            .shadow(
                color: Color.theme.accent.opacity(0.15),
                radius: 10, x: 0, y: 0)
            .offset(x: mainVM.animateStatus == .cross ? (UIScreen.main.bounds.width / 1.5) : 0)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    @StateObject static var mainVM = MainViewModel()
    static var previews: some View {
        HomeView(mainVM: mainVM)
    }
}
