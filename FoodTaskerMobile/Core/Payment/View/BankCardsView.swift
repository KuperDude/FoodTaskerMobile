//
//  BankCardsView.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 24.01.2023.
//

import SwiftUI
import TinkoffASDKCore

struct BankCardsView: UIViewControllerRepresentable {
    
    @ObservedObject var vm: PaymentViewModel
    @Environment(\.dismiss) var dismiss
    @Binding var isShow: Bool
    @Binding var isSuccess: Bool
    
    init(mainVM: MainViewModel, restaurantID: Int?, isShow: Binding<Bool>, isSuccess: Binding<Bool>) {
        self._vm = ObservedObject(initialValue: PaymentViewModel(address: mainVM.address, items: mainVM.order, restaurantID: restaurantID, deliveryPrice: mainVM.deliveryPrice))
        self._isShow = isShow
        self._isSuccess = isSuccess
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        UIViewController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        if isShow {
            TransactionManager.instance.placeOrder(on: uiViewController) { result in
                UIApplication.shared.endEditing()
                dismiss()
                
                switch result {
                case .failure(let error):
                    if error.localizedDescription == "Server error: 403" {
                        Task {
                            await vm.createOrder()
                        }
                        isSuccess = true
                    }
                default: break
                }
            }
        }
    }
        
}
