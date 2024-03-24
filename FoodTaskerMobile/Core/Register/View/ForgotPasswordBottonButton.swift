//
//  ForgotPasswordBottonButton.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 18.02.2024.
//

import SwiftUI

struct ForgotPasswordBottomButton: View {
    var title: String
    var action: ()->Void
    var body: some View {
        Button {
            action()
        } label: {
            Text(title)
                .frame(maxWidth: .infinity)
                .padding(.vertical)
                .background(in: RoundedRectangle(cornerRadius: 10))
                .backgroundStyle(.blue)
                .padding()
        }
    }
}

#Preview {
    ForgotPasswordBottomButton(title: "", action: {})
}
