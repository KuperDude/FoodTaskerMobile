//
//  HomeView.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 08.12.2022.
//

import SwiftUI
import vk_ios_sdk

struct MenuView: View {
    @ObservedObject var mainVM: MainViewModel
    
    var body: some View {
        ZStack(alignment: .leading) {
            //background
            Color.theme.background
                .ignoresSafeArea()
            
            //content
            GeometryReader { _ in
                VStack {
                    userData
                    
                    menuItems
                    
                    Spacer()
                }
                .frame(width: UIScreen.main.bounds.width / 1.5)
            }
        }
    }
}

struct MenuView_Previews: PreviewProvider {
    @StateObject static var mainVM: MainViewModel = MainViewModel()
    static var previews: some View {
        MenuView(mainVM: mainVM)
//            .environmentObject(mainVM)
    }
}

extension MenuView {
    var userData: some View {
        HStack(spacing: 20) {
            AsyncImage(url: URL(string: mainVM.user?.imageURL ?? ""))
                .clipShape(Circle())
            
            Text((mainVM.user?.fullName ?? "<<ERROR>>"))
                .lineLimit(2)
                .foregroundColor(.theme.accent)
                .font(.system(size: 20))
                .fontWeight(.semibold)
                .minimumScaleFactor(0.8)
            
            Spacer()
        }
        .padding(.top, 10)
        .padding(.leading, 20)
        .padding(.trailing, 5)
        .padding(.bottom, 50)
    }
    
    var menuItems: some View {
        ForEach(MainViewModel.Category.allCases) { category in
            Divider()
            MenuCell(category: category)
                .onTapGesture {
                    if category == .logout {
                        VKSdk.forceLogout()
                        UserDefaults.standard.setValue(nil, forKey: "fullName")
                        AuthService.instance.user = nil
                        APIManager.instance.logout { _ in }
                    }
                    mainVM.currentCategory = category
                }
        }
    }
}
