//
//  ProfileView.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 22.04.2024.
//

import SwiftUI

struct ProfileView: View {
    @ObservedObject var mainVM: MainViewModel
    @StateObject var vm = ProfileViewModel()
    
    init(mainVM: MainViewModel) {
        self.mainVM = mainVM
    }
    
    @State private var showAlert = false
    @State private var isShowAlertError = false

    var body: some View {
        ZStack {
            //background
            Color.theme.background
                .ignoresSafeArea()
            
            //content
            VStack {
                HStack {
                    MenuButtonView(mainVM: mainVM)
                    
                    Spacer()
                }
                
                Button {
                    showAlert.toggle()
                } label: {
                    Text("Удалить аккаунт")
                        .font(.headline)
                        .fontWeight(.heavy)
                        .foregroundStyle(Color.theme.red)
                        .underline()
                }

                Spacer()
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Вы уверены, что хотите удалить аккаунт?"),
                primaryButton: .cancel(Text("Отмена")),
                secondaryButton: .destructive(Text("Удалить")) {
                    vm.delete {
                        mainVM.user = nil
                        mainVM.currentCategory = .menu
                        mainVM.animateStatus = .burger
                        mainVM.order = []
                        mainVM.address = Address()
                    }
                }
            )
        }
        .onChange(of: vm.alertStatus, perform: { status in
            guard let _ = status else { return }
            isShowAlertError = true
        })
        .alert(vm.errorText(vm.alertStatus) ?? "", isPresented: $isShowAlertError) {
            Button("OK", role: .cancel) {
                vm.alertStatus = nil
            }
        }
    }
}

#Preview {
    ProfileView(mainVM: MainViewModel())
}
