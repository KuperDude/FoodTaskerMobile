//
//  SendCodeOnMailView.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 19.02.2024.
//

import SwiftUI

struct SendCodeOnMailView: View {
    
    @State private var isOpenKeyboard = false
    
    @Binding var isOpen: Bool
    @Binding var code: Int?
    
    @State var internalCode: String = ""
    
    @State var noEqualCodeAlert = false
    @State var noExistCodeAlert = false
    
    var resendCode: () -> Void
    var completion: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            
            if isOpen {
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
        .alert("Код не совпадает", isPresented: $noEqualCodeAlert) {
            Button("OK", role: .cancel) {
                noEqualCodeAlert = false
            }
        }
        .alert("Проблемы с приходом кода", isPresented: $noExistCodeAlert) {
            Button("OK", role: .cancel) {
                noExistCodeAlert = false
            }
        }
    }
}

#Preview {
    SendCodeOnMailView(isOpen: .constant(true), code: .constant(123), resendCode: {}, completion: {})
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
            CodeTextFields(code: $internalCode)
            
            TimerView(action: resendCode)
            
            Spacer()
            
            ForgotPasswordBottomButton(title: "Подтвердить") {
                guard 
                    let code = code,
                    let internalCode = Int(internalCode)
                else {                    
                    noExistCodeAlert = true
                    return
                }
                
                if code == internalCode {
                    self.internalCode = ""
                    self.code = nil
                    completion()
                } else {
                    noEqualCodeAlert = true
                }
                
            }
        }
        .frame(height: 230)
    }
}
