//
//  HomeView.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 08.12.2022.
//

import SwiftUI

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
                    currentCategory = category
                }
        }
    }
}
