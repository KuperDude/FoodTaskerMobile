//
//  HomeView.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 08.12.2022.
//

import SwiftUI
import vk_ios_sdk

struct MenuView: View {
    @Binding var currentCategory: MenuCell.Category
    
    var body: some View {
        ZStack {
            //background
            Color.theme.background
                .ignoresSafeArea()
            
            //content
            VStack {
                userData
                
                menuItems
                
                Spacer()
            }
        }
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView(currentCategory: .constant(.restaurants))
    }
}

extension MenuView {
    var userData: some View {
        HStack(spacing: 20) {
            Image("background_img")
                .resizable()
                .frame(width: 70, height: 70)
                .clipShape(Circle())
            
            Text("Greg Fields")
                .foregroundColor(.theme.accent)
                .font(.system(size: 20))
                .fontWeight(.semibold)
            
            Spacer()
        }
        .padding(20)
        .padding(.bottom, 50)
    }
    
    var menuItems: some View {
        ForEach(MenuCell.Category.allCases) { category in
            Divider()
            MenuCell(category: category)
                .onTapGesture {
                    if category == .logout {
                        VKSdk.forceLogout()
                        AuthService.instance.isLoggin = false
                    }
                    currentCategory = category
                }
        }
    }
}
