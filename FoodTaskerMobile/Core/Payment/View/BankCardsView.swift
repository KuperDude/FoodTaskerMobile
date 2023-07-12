//
//  BankCardsView.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 24.01.2023.
//

import SwiftUI

struct BankCardsView: UIViewControllerRepresentable {
    
    @ObservedObject var vm: PaymentViewModel
    @Binding var isShow: Bool
    
    func makeUIViewController(context: Context) -> UIViewController {
        UIViewController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        if isShow {
            TransactionManager.instance.placeOrder(on: uiViewController)
        }
    }
        
}
