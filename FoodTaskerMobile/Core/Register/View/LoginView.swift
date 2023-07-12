//
//  ContentView.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 04.12.2022.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var mainVM: MainViewModel
    
    @ObservedObject var vm: LoginViewModel
    @State private var selectedRole = 1
    
    init(mainVM: MainViewModel) {
        self._mainVM = ObservedObject(initialValue: mainVM)
        self.vm = LoginViewModel(user: mainVM.user)
    }
    
    var body: some View {        
        // content
        VStack(spacing: 20) {
            nameApp
            createdBy
            
            Spacer()
            
            VStack(spacing: 35) {
                picker
                loginButton
            }
            .padding(.horizontal, 20)
        }
        .background {
            // background
            backgroundImage
        }
        .onChange(of: vm.user, perform: { user in
            mainVM.user = user
        })
        .fullScreenCover(item: $vm.user, content: { user in
            HomeView(mainVM: mainVM)
        })
    }
}

struct LoginView_Previews: PreviewProvider {
//    static var mainVM = MainViewModel()
    static var previews: some View {
        LoginView(mainVM: MainViewModel())
//            .environmentObject(mainVM)
    }
}

extension LoginView {
    var nameApp: some View {
        Text("FoodTasker")
            .font(.custom("Avenir Next", size: 49))
            .fontWeight(.bold)
            .foregroundColor(.white)
            .padding(.top, 135)
    }
    
    var createdBy: some View {
        Text("created by Greg Fields")
            .foregroundColor(Color.init(uiColor: .lightGray))
    }
    
    var picker: some View {
        Picker("role", selection: $selectedRole) {
            Text("Customer").tag(0)
            Text("Driver").tag(1)
        }
        .background(content: {
            Color.white
        })
        .pickerStyle(.segmented)
    }
    
    var loginButton: some View {
        Button {
            vm.wakeUpSession()
        } label: {
            Text(vm.getButtonTitle())
                .minimumScaleFactor(0.5)
                .font(.system(size: 17))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background {
                    Color.theme.green
                }
                .padding(.bottom, 50)
        }
    }
    
    var backgroundImage: some View {
        Image("background_img")
            .resizable()
            .ignoresSafeArea()
            .scaledToFill()
    }
}
