//
//  CartView.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 13.12.2022.
//

import SwiftUI
import MapKit

struct CartView: View {
    @ObservedObject var mainVM: MainViewModel
    @StateObject var vm = CartViewModel()
    
    @State private var showAddressAlert = false
    @State private var showOrderAlert = false
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
                HStack {
                    MenuButtonView(mainVM: mainVM) 
                    
                    Spacer()
                }
                
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
        
        GeometryReader { geometry in
            CompositionView(mainVM: mainVM, mealId: mainVM.order.first(where: { $0.id == orderDetailsIdToCompositionView})?.meal.id ?? -1, orderDetailsId: orderDetailsIdToCompositionView)
                .presentAsBottomSheet($presentCompositionView, maxHeight: geometry.size.height * 0.5)
        
            AddressesView(presentAddressesView: $presentAddressesView, mainVM: mainVM)
                .presentAsBottomSheet($presentAddressesView, maxHeight: geometry.size.height * 0.5)
        }
    }
}

struct CartView_Previews: PreviewProvider {
    static var previews: some View {
        CartView(mainVM: MainViewModel(order: [OrderDetails(meal: Meal(id: 1, name: "Burger", shortDescription: "", image: "", price: 130.0, category: Category(id: 1, name: "meal")), quantity: 2, id: UUID())]))
    }
}

extension CartView {
    
    var content: some View {
        VStack {
            VStack {
                ScrollView(showsIndicators: false) {
                    ForEach(mainVM.order) { orderDetails in
                        CartCell(mainVM: mainVM, orderDetails: orderDetails) {
                            orderDetailsIdToCompositionView = orderDetails.id
                            presentCompositionView = true
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
            Text(mainVM.order.total.asCurrencyWith2Decimals())
                .font(.system(size: 18))
                .foregroundColor(.theme.green)
                .padding()
        }
    }
    
    var payButton: some View {
        Button {
            if mainVM.address.isEmpty() {
                showAddressAlert = true
            } else if vm.getStatus() != .delivered && vm.getStatus() != .unknown && vm.getStatus() != .cancelled {
                showOrderAlert = true
            } else {
                withAnimation(.spring()) {
                    showPayment = true
                }
            }
        } label: {
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
                .opacity(mainVM.address.isEmpty() ? 0.5 : 1.0)
        }
    }
}
