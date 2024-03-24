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
    @Binding var code: String
    
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
    }
}

#Preview {
    SendCodeOnMailView(isOpen: .constant(true), code: .constant(""))
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
            CodeTextFields(code: $code)
            
            TimerView(action: {})
            
            Spacer()
            
            ForgotPasswordBottomButton(title: "Подтвердить") {
                //vm.codeButtonAction()
            }
        }
        .frame(height: 230)
    }
}
