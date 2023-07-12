//
//  CartPaymentView.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 16.12.2022.
//

import SwiftUI
import Lottie
import TinkoffASDKUI
import TinkoffASDKCore

struct CartPaymentView: View {
    @ObservedObject var mainVM: MainViewModel
    
    @State private var isShow = false
    @ObservedObject var vm: PaymentViewModel
    
    init(mainVM: MainViewModel) {
        self._mainVM = ObservedObject(initialValue: mainVM)
        self._vm = ObservedObject(initialValue: PaymentViewModel(address: mainVM.address, items: mainVM.order, restaurantId: mainVM.selectedRestaurantId))
    }
    
    var body: some View {
        VStack {
            CreditCardAnimationView()
                .frame(height: 200)
                .padding()
//            PaymentCardTextField(cardParams: $vm.cardParams)
//                .frame(height: 80)
//                .padding(.horizontal)
            
            Button {
                isShow = true
                //vm.placeOrder()                
                Task {
                    await vm.createOrder()
                }
            } label: {
                Text("Continue")
            }
            BankCardsView(vm: vm, isShow: $isShow)

            
            Spacer()
        }
        .alert("Already order?", isPresented: $vm.isShowAlert) {
            
            Button(role: .cancel) {
                vm.isShowAlert = false
            } label: {
                Text("Cancel")
            }
            
            Button {
                // go to view delivery
            } label: {
                Text("Go to order")
            }
            


        } message: {
            Text("Your current order is not completed")
        }
    }
}

struct CartPaymentView_Previews: PreviewProvider {
    @StateObject static var mainVM = MainViewModel()
    static var previews: some View {
        CartPaymentView(mainVM: mainVM)
    }
}
