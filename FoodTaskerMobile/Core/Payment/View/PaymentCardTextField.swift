//
//  PaymentCardTextField.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 17.12.2022.
//

import SwiftUI
import Stripe

struct PaymentCardTextField: UIViewRepresentable {
    
    @Binding var cardParams: STPPaymentMethodParams?
    
    func makeUIView(context: Context) -> STPPaymentCardTextField {
//        let view = UIView()
        
        let cardTextField = STPPaymentCardTextField()
        cardTextField.delegate = context.coordinator
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
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(cardParams: $cardParams)
    }
    
    
    class Coordinator: NSObject, STPPaymentCardTextFieldDelegate {
        @Binding var cardParams: STPPaymentMethodParams?
        
        init(cardParams: Binding<STPPaymentMethodParams?>) {
            self._cardParams = cardParams
        }
        
        func paymentCardTextFieldDidChange(_ textField: STPPaymentCardTextField) {
            cardParams = textField.paymentMethodParams
        }
    }
}

struct PaymentCardTextField_Previews: PreviewProvider {
    static var previews: some View {
        PaymentCardTextField(cardParams: .constant(STPPaymentMethodParams()))
    }
}

