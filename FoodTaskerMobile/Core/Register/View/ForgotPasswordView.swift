//
//  ForgotPasswordView.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 15.02.2024.
//

import SwiftUI

struct ForgotPasswordView: View {
    
    @StateObject var vm = ForgotPasswordViewModel()
    @State private var isOpenKeyboard = false
    @Binding var isOpen: Bool
    
    var body: some View {
        ForgotPasswordSegment(vm: vm)
            .presentAsBottomSheet($isOpen, maxHeight: isOpenKeyboard ? 550 : 350)
            .onChange(of: vm.state) { state in
                isOpen = state != .closed ? true : false
            }
            .onChange(of: isOpen, perform: { isOpen in
                if isOpen && vm.state == .closed {
                    vm.changeState()
                }
                if !isOpen {
                    vm.close()
                }
            })
            .onKeyboardAppear { bool in
                withAnimation(.spring) {
                    isOpenKeyboard = bool
                }
            }
    }
}

#Preview {
    ForgotPasswordView(isOpen: .constant(true))
}
