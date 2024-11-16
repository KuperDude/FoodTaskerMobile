//
//  ContentView.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 04.12.2022.
//

import SwiftUI
import GoogleSignInSwift
import GoogleSignIn
import SwiftfulUI

struct LoginView: View {
    @ObservedObject var mainVM: MainViewModel
    
    @ObservedObject var vm: LoginViewModel
    
    @State var isRegistration = false
    @State var isShowAlert = false
    
    @State var pressedForgotPassword = false
    @State var pressedRegistration = false
    
    init(mainVM: MainViewModel) {
        self._mainVM = ObservedObject(initialValue: mainVM)
        self.vm = LoginViewModel(user: mainVM.user)
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                Spacer()
                
                nameApp
                
                createdBy
                
                VStack(spacing: 20) {
                    if !isRegistration {
                        Spacer()
                    }
                    LoginPickerView(isRegistration: $isRegistration)
                    
                    textFieldsSegment
                    
                    loginButton
                    
                    if !isRegistration {
                        forgotPasswordButton
                    }
                                        
                    anotherRegistrationServices
                    
                    loginAsAnonymousButton
                }
                Button {
                    if let url = URL(string: "https://vk.com/app52209597/") {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
//                    "https://oauth.yandex.ru/authorize?response_type=token&client_id=28999056b028449b9797216ab6c53510"
                } label: {
                    Text("Take phone")
                }
            }
            .padding(.horizontal, 20)
            .background {
                backgroundImage
            }
            
            
            ForgotPasswordView(isOpen: $pressedForgotPassword)
            SendCodeOnMailView(code: $vm.code, mail: vm.mail) {
                vm.register()
                pressedRegistration = false
            }
            
        }
        .task {
            if await vm.wakeUpSession(.vk, isAlreadyLogin: true) {
                return
            }
            if await vm.wakeUpSession(.google, isAlreadyLogin: true) {
                return
            }
        }
        .onChange(of: vm.user, perform: { user in
            mainVM.user = user
        })
        .fullScreenCover(item: $vm.user, content: { user in
            HomeView(mainVM: mainVM)
        })
        .onChange(of: vm.alertStatus, perform: { status in
            guard let _ = status else { return }
            isShowAlert = true
        })
        .alert(vm.errorText(vm.alertStatus) ?? "", isPresented: $isShowAlert) {
            Button("OK", role: .cancel) {
                vm.alertStatus = nil
            }
        }
        .onReceive(vm.$code, perform: { code in
            guard let _ = code else { return }
            UIApplication.shared.endEditing()
            pressedRegistration = true
        })
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(mainVM: MainViewModel())
    }
}

extension LoginView {
    var nameApp: some View {
        Text("StreetFood")
            .font(.custom("Avenir Next", size: 49))
            .fontWeight(.bold)
            .foregroundColor(.white)
    }
    
    var createdBy: some View {
        Text("Автор: Григорий Поляков")
            .foregroundColor(Color.init(uiColor: .lightGray))
    }
    
    
    var textFieldsSegment: some View {
        VStack(spacing: 0) {
            if isRegistration {
                TextField("Имя", text: $vm.username)
                    .textFieldStyle(text: $vm.username)
            }
               
            TextField("Почта", text: $vm.mail)
                .textFieldStyle(text: $vm.mail)
            
            SecureField("Пароль", text: $vm.password1)
                .textFieldStyle(text: $vm.password1)
            
            if isRegistration {
                SecureField("Повтор пароля", text: $vm.password2)
                    .textFieldStyle(text: $vm.password2)
            }
        }
    }
    
    var loginButton: some View {
        AsyncButton {
            if isRegistration {
                if vm.checkCurrectData() {
                    await vm.sendCode()
                }
            } else {
                if vm.checkCurrectDataOnLogin() {
                    vm.loginOnMail()
                }
            }
        } label: { isPerformingAction in
            ZStack {
                 if isPerformingAction {
                       ProgressView()
                 }
                   
                Text(isRegistration ? "Продолжить" : "Войти")
                    .opacity(isPerformingAction ? 0 : 1)
            }
            .minimumScaleFactor(0.5)
            .font(.system(size: 17))
            .foregroundColor(.theme.accent)
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(Color.theme.green)
            }
        }
    }
    
    var backgroundImage: some View {
        Image("background_img")
            .resizable()
            .ignoresSafeArea(.all)
            .scaledToFill()
    }
    
    var anotherRegistrationServices: some View {
        HStack {
            AsyncButton {
                await vm.wakeUpSession(.vk)
            } label: { isPerformingAction in
                ZStack {
                    Image("vk_logo")
                        .resizable()
                        .scaledToFill()
                        .opacity(isPerformingAction ? 0.5 : 1)
                    
                    if isPerformingAction {
                          ProgressView()
                    }
                }
                .frame(width: 60, height: 60)
            }
            
            Spacer()
            
            AsyncButton {
                await vm.wakeUpSession(.google)
            } label: { isPerformingAction in
                ZStack {
                    Image("google_logo")
                        .resizable()
                        .scaledToFill()
                        .opacity(isPerformingAction ? 0.5 : 1)
                    
                    if isPerformingAction {
                          ProgressView()
                    }
                }
                .frame(width: 60, height: 60)
                .background(content: { Color.white })
                .clipShape(Circle())
            }
        }
        .padding(.horizontal, 30)
       // .padding(.bottom, 50)
    }
    
    var forgotPasswordButton: some View {
        Text("Забыли свой пароль?")
            .foregroundColor(Color.init(uiColor: .lightGray))
            .underline()
            .onTapGesture {
                UIApplication.shared.endEditing()
                pressedForgotPassword = true
            }
    }
    
    var loginAsAnonymousButton: some View {
        Text("Войти без регистрации")
            .foregroundColor(Color.init(uiColor: .lightGray))
            .underline()
            .onTapGesture {
                UIApplication.shared.endEditing()
                vm.authService.user = User(id: "Anonymous", firstName: "Anonymous", lastName: "", imageURL: "")
            }
            .padding(.bottom, 50)
    }
}
