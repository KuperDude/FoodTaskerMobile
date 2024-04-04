//
//  LoginPickerView.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 19.02.2024.
//

import SwiftUI

struct LoginPickerView: View {
    
    @Binding var isRegistration: Bool
    
    @Namespace var animation
    
    var body: some View {
        HStack {
            
            Button {
                withAnimation {
                    isRegistration = false
                }
            } label: {
                Text("Вход")
                    .foregroundStyle(Color.theme.accent)
                    .padding()
            }
            .matchedGeometryEffect(id: 0, in: animation, isSource: !isRegistration)
            .frame(maxWidth: .infinity)
            
            Button {
                withAnimation {
                    isRegistration = true
                }
            } label: {
                Text("Регистрация")
                    .foregroundStyle(Color.theme.accent)
                    .padding()
            }
            .matchedGeometryEffect(id: 1, in: animation, isSource: isRegistration)
            .frame(maxWidth: .infinity)
        }
        .background {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.theme.red)
                .matchedGeometryEffect(id: isRegistration ? 1 : 0, in: animation, isSource: false)
        }
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.theme.background)
                .padding(.vertical, -5)
                .shadow(
                    color: Color.theme.accent.opacity(0.15),
                    radius: 10, x: 0, y: 0)
        )
    }
}

#Preview {
    LoginPickerView(isRegistration: .constant(true))
}
