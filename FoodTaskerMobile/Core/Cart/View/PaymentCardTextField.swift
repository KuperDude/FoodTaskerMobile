//
//  PaymentCardTextField.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 17.12.2022.
//

import SwiftUI
import Stripe

struct PaymentCardTextField: UIViewRepresentable {
    
    func makeUIView(context: Context) -> STPPaymentCardTextField {
//        let view = UIView()
        
        let cardTextField = STPPaymentCardTextField()
        cardTextField.postalCodeEntryEnabled = false
        
//        view.addSubview(cardTextField)
//
//        NSLayoutConstraint.activate([
//            cardTextField.heightAnchor.constraint(equalTo: view.heightAnchor),
//            cardTextField.widthAnchor.constraint(equalTo: view.widthAnchor),
//        ])
        
        return cardTextField
    }
    
    func updateUIView(_ uiView: STPPaymentCardTextField, context: Context) {}
}

struct PaymentCardTextField_Previews: PreviewProvider {
    static var previews: some View {
        PaymentCardTextField()
    }
}

