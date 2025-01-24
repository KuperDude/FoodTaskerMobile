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
            
            if mainVM.isUserAnonymous() {
                
                anonymousSection
                
            }
            
            Group {
                ProfileView(mainVM: mainVM)
                    .opacity(mainVM.currentCategory == .profile ? 1 : 0)

                MealView(mainVM: mainVM)
                    .opacity(mainVM.currentCategory == .menu ? 1 : 0)

                CartView(mainVM: mainVM)
                    .opacity(mainVM.currentCategory == .cart ? 1 : 0)
                
                SupportView(mainVM: mainVM)
                    .opacity(mainVM.currentCategory == .technicalSupport ? 1 : 0)
                
                if mainVM.currentCategory == .delivery {
                    DeliveryView(mainVM: mainVM)
                }

                EmptyView()
                    .opacity(mainVM.currentCategory == .logout ? 1 : 0)
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

extension HomeView {
    var anonymousSection: some View {
        ZStack {
            Rectangle()
                .foregroundStyle(Color.theme.background)
                .opacity(0.9)
                .ignoresSafeArea()
                .blur(radius: 70)
            
            HStack {
                Button {
                    mainVM.moveToLoginView()
                } label: {
                    Text("Регистрация")
                        .font(.headline)
                        .fontWeight(.heavy)
                        .foregroundStyle(Color.theme.accent)
                        .underline()
                        .padding()
                        .background {
                            RoundedRectangle(cornerRadius: 12)
                                .foregroundStyle(Color.theme.green)
                        }
                }
                .padding(.leading, 30)
                .buttonStyle(NoAnim())
                
                Spacer()
            }
        }
    }
}
