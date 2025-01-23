//
//  CartView.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 13.12.2022.
//

import SwiftUI
import MapKit
import SwiftfulUI

struct CartView: View {
    @ObservedObject var mainVM: MainViewModel
    @StateObject var vm = CartViewModel()
    
    @State private var showAddressAlert = false
    @State private var showOrderAlert = false
    @State private var showLoginAlert = false
    @State private var isShowAlert = false
    
    @State var showPayment = false
    @State var showSuccessPayment = false
    
    @State private var orderDetailsIdToCompositionView: UUID?
    @State private var presentCompositionView: Bool = false
    @State private var presentAddressesView: Bool = false
    
    var body: some View {
        ZStack {
            //background
            Color.theme.background
                .ignoresSafeArea()
            
            //content
            VStack {
                
                topSector
                
                if mainVM.order.isEmpty {
                    Text("Ваша корзина пуста")
                        .font(.headline)
                        .fontWidth(.compressed)
                        .foregroundStyle(Color.theme.secondaryText)
                        .padding()
                    
                    SadSmileAnimationView()
                        .frame(width: 200, height: 200)
                    
                } else {
                    
                    content
                    
                }
                Spacer()
                
            }
            .ignoresSafeArea(edges: .bottom)
            .sheet(isPresented: $showPayment, content: {
                BankCardsView(mainVM: mainVM, isShow: $showPayment, isSuccess: $showSuccessPayment)
            })
            
            SuccessPaymentView()
                .presentAsBottomSheet($showSuccessPayment, maxHeight: 320)
        }
        .onChange(of: showSuccessPayment, perform: { showSuccessPayment in
            if !showSuccessPayment {
                withAnimation {
                    mainVM.currentCategory = .delivery
                    mainVM.animateStatus = .burger
                }
                mainVM.order = []
                mainVM.address = Address()
            }
        })
        .alert("Адрес", isPresented: $showAddressAlert) {
            Button("OK") {
                presentAddressesView = true
            }
        } message: {
            Text("Добавьте адрес доставки")
        }
        .alert("Заказ", isPresented: $showOrderAlert) {
            Button("OK") {
                withAnimation {
                    mainVM.currentCategory = .delivery
                    mainVM.animateStatus = .burger
                }
            }
        } message: {
            Text("Ваш текущий заказ ещё не выполнен")
        }
        .onChange(of: presentCompositionView) { bool in
            if !bool {
                mainVM.removeDublicateOrderDetails(at: orderDetailsIdToCompositionView)
            }
        }
        .alert("Регистрация", isPresented: $showLoginAlert) {
            Button("OK") {
                mainVM.moveToLoginView()
            }
        } message: {
            Text("Войдите в аккаунт или пройдите регистрацию")
        }
        .onChange(of: vm.errorDescription) { errorDescription in
            guard let _ = errorDescription else { return }
            isShowAlert = true
        }
        .alert(vm.errorDescription ?? "", isPresented: $isShowAlert) {
            Button("OK", role: .cancel) {
                vm.errorDescription = nil
            }
        }
        
        GeometryReader { geometry in
            if presentCompositionView {
                CompositionView(mainVM: mainVM, mealId: mainVM.order.first(where: { $0.id == orderDetailsIdToCompositionView})?.meal.id ?? -1, orderDetailsId: orderDetailsIdToCompositionView)
                    .presentAsBottomSheet($presentCompositionView, maxHeight: geometry.size.height * 0.5)
                    .offset(y: presentCompositionView ? 0 : -geometry.size.height * 0.5)
            }
        
            AddressesView(presentAddressesView: $presentAddressesView, mainVM: mainVM)
                .presentAsBottomSheet($presentAddressesView, maxHeight: geometry.size.height * 0.5)
        }
    }
}

struct CartView_Previews: PreviewProvider {
    static var previews: some View {
        CartView(mainVM: MainViewModel(order: [OrderDetails(meal: Meal(id: 1, name: "Burger", shortDescription: "", image: "", price: 130.0, category: Category(id: 1, name: "meal", order: 0)), quantity: 2, id: UUID())]))
    }
}

extension CartView {
    
    var topSector: some View {
        HStack {
            MenuButtonView(mainVM: mainVM)
            
            Spacer()
        }
    }
    
    var content: some View {
        VStack {
            VStack {
                ScrollView(showsIndicators: false) {
                    ForEach(mainVM.order) { orderDetails in
                        CartCell(mainVM: mainVM, orderDetails: orderDetails) {
                            orderDetailsIdToCompositionView = orderDetails.id
                            withAnimation {
                                presentCompositionView = true
                            }
                        }
                        Divider()
                    }
                    
                    
                    CDeliveryCell(mainVM: mainVM, onTap: {
                        presentAddressesView = true
                    })
                    Rectangle()
                        .frame(height: 5)
                        .opacity(0.001)
                }
                Divider()
                
                price
                
                payButton

            }
            .padding()
        }
        .transition(.move(edge: .leading))
    }
    
    var price: some View {
        HStack {
            Text("Итог:")
                .foregroundColor(.theme.accent)
                .font(.system(size: 18, weight: .semibold))
            Spacer()
            Text(mainVM.total().asCurrencyWith2Decimals())
                .font(.system(size: 18))
                .foregroundColor(.theme.green)
                .padding()
        }
    }
    
    var payButton: some View {
        AsyncButton {
            vm.address = mainVM.address
            let status = await vm.getStatus()
            if mainVM.isUserAnonymous() {
                showLoginAlert = true
            } else if mainVM.address.isEmpty() {
                showAddressAlert = true
            } else if status != .delivered && status != .unknown && status != .cancelled {
                showOrderAlert = true
            } else {
                if await vm.checkToCreateOrder() {
                    withAnimation(.spring()) {
                        showPayment = true
                    }
                }
            }
        } label: { isPerformingAction in
            ZStack {
                Text("Оплатить")
                    .minimumScaleFactor(0.5)
                    .font(.system(size: 25))
                    .fontWidth(.compressed)
                    .foregroundColor(.theme.accent)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundStyle(Color.theme.green)
                    }
                    .opacity(isPerformingAction || mainVM.address.isEmpty() || mainVM.isUserAnonymous() ? 0.5 : 1)
                
                if isPerformingAction {
                      ProgressView()
                }
            }
        }
    }
}
