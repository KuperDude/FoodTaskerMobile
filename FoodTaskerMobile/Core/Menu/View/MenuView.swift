//
//  HomeView.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 08.12.2022.
//

import SwiftUI
import vk_ios_sdk
import GoogleSignIn

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
    }
}

extension MenuView {
    var userData: some View {
        HStack(spacing: 20) {
            AsyncImage(url: URL(string: mainVM.user?.imageURL ?? ""))
                .frame(width: 50, height: 50)
                
                .overlay {
                    if mainVM.user?.imageURL == nil || mainVM.user?.imageURL == "" {
                        Image(systemName: "person.fill")
                            .resizable()
                    }
                }
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
        .onTapGesture {
            
            mainVM.currentCategory = .profile
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation {
                    mainVM.animateStatus.newStatusOnTap()
                }
            }
        }
    }
    
    var menuItems: some View {
        ForEach(MainViewModel.Category.allCases) { category in
            if category != .profile {
                Divider()
                MenuCell(category: category)
                    .onTapGesture {
                        if category == .logout {
                            VKSdk.forceLogout()
                            GIDSignIn.sharedInstance.signOut()
                            AuthManager.instance.user = nil
                            APIManager.instance.logout(.vk) { _ in }
                            APIManager.instance.logout(.google) { _ in }
                            mainVM.user = nil
                            mainVM.currentCategory = .menu
                            mainVM.animateStatus = .burger
                            mainVM.order = []
                            mainVM.address = Address()
                            return
                        }
                        
                        mainVM.currentCategory = category
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            withAnimation {
                                mainVM.animateStatus.newStatusOnTap()
                            }
                        }
                    }
            }
        }
    }
}
