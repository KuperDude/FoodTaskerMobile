//
//  SuccessPaymentView.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 22.03.2024.
//

import SwiftUI

struct SuccessPaymentView: View {
    var body: some View {
        VStack {
            Image(systemName: "checkmark.circle.fill")
                .resizable()
                .frame(width: 200, height: 200)
                .foregroundStyle(Color.theme.green)
            Text("Оплата успешно прошла!")
                .foregroundStyle(Color.theme.accent)
                .font(.title)
                .fontWidth(.compressed)
        }
    }
}

#Preview {
    SuccessPaymentView()
}
