//
//  CartPaymentView.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 16.12.2022.
//

import SwiftUI
import Lottie

struct CartPaymentView: View {
    var body: some View {
        VStack {
            CreditCardAnimationView()
                .frame(height: 200)
                .padding()
            PaymentCardTextField()
                .frame(height: 80)
                .padding(.horizontal)
            
            Spacer()
        }
    }
}

struct CartPaymentView_Previews: PreviewProvider {
    static var previews: some View {
        CartPaymentView()
    }
}
