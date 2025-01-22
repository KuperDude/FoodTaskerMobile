//
//  SendCodeOnMailView.swift
//  LMS_Mobile
//
//  Created by MyBook on 02.07.2024.
//

import SwiftUI

struct SendCodeOnMailView: View {
    
    @StateObject private var vm: SendCodeOnMailViewModel
    
    @State var isShowAlert = false
    @State private var isOpenKeyboard = false

    @Binding var isOpen: Bool
    @Binding var mail: String
    
    var completion: () -> Void
    
    init(isOpen: Binding<Bool>, mail: Binding<String>, completion: @escaping () -> Void) {
        self._vm = StateObject(wrappedValue: SendCodeOnMailViewModel(mail: mail.wrappedValue, completion: completion))
        self._isOpen = isOpen
        self._mail = mail
        self.completion = completion
    }
    
    var body: some View {
        VStack(spacing: 0) {
            
            if vm.code != nil {
                codeSegment
            }
            
            Spacer()
        }
        .presentAsBottomSheet($isOpen, maxHeight: isOpenKeyboard ? 550 : 350)
        .onKeyboardAppear { bool in
            withAnimation(.spring) {
                isOpenKeyboard = bool
            }
        }
        .onChange(of: vm.code) { internalCode in
            if internalCode != nil {
                isOpen = true
            } else {
                isOpen = false
            }
        }
        .onChange(of: isOpen) { isOpen in
            if isOpen {
                Task {
                    await vm.sendCode()
                }
            } else {
                vm.code = nil
            }
        }
        .onChange(of: mail) { mail in
            vm.mail = mail
        }
        .onChange(of: vm.alertStatus) { status in
            guard let _ = status else { return }
            isOpen = false
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
    ZStack {
        SendCodeOnMailView(isOpen: .constant(true), mail: .constant("mail"), completion: {
            
        })
    }
}

extension SendCodeOnMailView {
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
        .frame(height: 230)
    }
}

