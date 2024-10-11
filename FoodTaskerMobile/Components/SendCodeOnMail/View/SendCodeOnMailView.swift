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
    
    @Binding var code: Int?
    @State var isOpen: Bool
    
    var completion: () -> Void
    
    init(code: Binding<Int?>, mail: String, completion: @escaping () -> Void) {
        self._vm = StateObject(wrappedValue: SendCodeOnMailViewModel(mail: mail, completion: completion))
        self._code = code
        self.isOpen = code.wrappedValue != nil
        self.completion = completion
    }
    
    var body: some View {
        VStack(spacing: 0) {
            
            if code != nil {
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
        .onChange(of: code) { internalCode in
            if internalCode != nil {
                isOpen = true
            } else {
                isOpen = false
            }
        }
        .onChange(of: isOpen) { isOpen in
            if !isOpen {
                code = nil
            }
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
    ZStack {
        SendCodeOnMailView(code: .constant(123), mail: "mail", completion: {
            
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

