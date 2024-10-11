//
//  ForgotPasswordSegment.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 13.02.2024.
//

import SwiftUI
import SwiftfulUI

struct ForgotPasswordSegment: View {
    
    @ObservedObject var vm: ForgotPasswordViewModel
    
    @State var isShowAlert = false
    
    var body: some View {
        VStack(spacing: 0) {
            
            VStack {
                switch vm.state {
                case .mail:  mailSegment
                case .code:  codeSegment
                case .reset: resetSegment
                case .ready: readySegment
                default:
                    EmptyView()
                }
            }
            .frame(height: 230)
            
            Spacer()
            
            bottomCircleSegment
            
            Spacer()
        }
        .onChange(of: vm.alertStatus) { status in
            guard let _ = status else { return }
            isShowAlert = true
        }
        .alert(vm.errorText(vm.alertStatus) ?? "", isPresented: $isShowAlert) {
            Button("OK", role: .cancel) {
                vm.alertStatus = nil
            }
        }
    }
}

#Preview {
    
    ScrollView {
        ForgotPasswordSegment(vm: ForgotPasswordViewModel(state: .mail))
        Divider()
        ForgotPasswordSegment(vm: ForgotPasswordViewModel(state: .code))
        Divider()
        ForgotPasswordSegment(vm: ForgotPasswordViewModel(state: .reset))
        Divider()
        ForgotPasswordSegment(vm: ForgotPasswordViewModel(state: .ready))
    }
    
    
}

extension ForgotPasswordSegment {
    
    var mailSegment: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Введите вашу почту:")
                    .foregroundStyle(.secondary)
                    .padding(.leading)
                Spacer()
            }
            
            TextField("Почта", text: $vm.mail)
                .textFieldStyle(text: $vm.mail)
            
            Spacer()
            
            
            AsyncButton {
                await vm.sendCode()
            } label: { isPerformingAction in
                ZStack {
                     if isPerformingAction {
                           ProgressView()
                     }
                       
                    Text("Отправить код")
                        .opacity(isPerformingAction ? 0 : 1)
                }
                .forgotPasswordButtonStyle()
           }
        }
    }
    
    var codeSegment: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Введите код, который пришёл на вашу почту:")
                    .foregroundStyle(.secondary)
                    .padding(.leading)
                Spacer()
            }
            CodeTextFields(code: $vm.internalCode)
            
            TimerView(action: {
                Task {
                    await vm.sendCode()
                }
            })
            
            Spacer()
            
            ForgotPasswordBottomButton(title: "Подтвердить") {
                vm.codeButtonAction()
            }
        }
    }
    
    var resetSegment: some View {
        VStack(spacing: 0) {
            SecureField("Новый пароль", text: $vm.password1)
                .textFieldStyle(text: $vm.password1)
            
            SecureField("Повторите пароль", text: $vm.password2)
                .textFieldStyle(text: $vm.password2)
            
            Spacer()
            
            AsyncButton {
                await vm.resetButtonAction()
            } label: { isPerformingAction in
                ZStack {
                     if isPerformingAction {
                           ProgressView()
                     }
                       
                    Text("Подтвердить")
                        .opacity(isPerformingAction ? 0 : 1)
                }
                .forgotPasswordButtonStyle()
           }
        }
    }
    
    var readySegment: some View {
        VStack {

            ResetPasswordAnimationView()
                .frame(width: 150, height: 160)

            Spacer()
            
            ForgotPasswordBottomButton(title: "Ваш пароль успешно изменен!") {
                vm.readyButtonAction()
            }
        }
    }
    
    var bottomCircleSegment: some View {
        HStack {
            Group {
                Circle()
                    .foregroundStyle(vm.state.rawValue > 1 ? .green : .secondary)
                Circle()
                    .foregroundStyle(vm.state.rawValue > 2 ? .green : .secondary)
                Circle()
                    .foregroundStyle(vm.state.rawValue > 3 ? .green : .secondary)
            }
            .frame(width: 5, height: 5)
        }
    }
}
