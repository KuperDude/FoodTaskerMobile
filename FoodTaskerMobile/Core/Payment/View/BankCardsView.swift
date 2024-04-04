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
    
    init(mainVM: MainViewModel, isShow: Binding<Bool>, isSuccess: Binding<Bool>) {
        self._vm = ObservedObject(initialValue: PaymentViewModel(address: mainVM.address, items: mainVM.order, restaurantId: mainVM.selectedRestaurantId))
        self._isShow = isShow
        self._isSuccess = isSuccess
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        UIViewController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        if isShow {
            TransactionManager.instance.placeOrder(on: uiViewController) { result in
                print(result)
                UIApplication.shared.endEditing()
                dismiss()
                
                switch result {
                case .failure(let error):
                    print(error.localizedDescription)
                    if error.localizedDescription == "Server error: 403" {
                        isSuccess = true
                        Task {
                            await vm.createOrder()
                        }
                    }
                default: break
                }
            }
        }
    }
        
}
