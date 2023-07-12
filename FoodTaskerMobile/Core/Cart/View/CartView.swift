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
    
    @State private var showAlert = false
    @FocusState private var focused: Bool
    
    @State private var orderDetailsIdToCompositionView: UUID?
    @State private var presentCompositionView: Bool = false
    
    var body: some View {
        ZStack {
            //background
            Color.theme.background
                .ignoresSafeArea()
            
            //content
            VStack {
                HStack {
                    MenuButtonView(mainVM: mainVM) {}
                    
                    Spacer()
                    
                    Button("Go to payment") {
                        if mainVM.address == "" {
                            showAlert = true
                        } else {
                            withAnimation(.spring()) {
                                mainVM.animateStatus = .chevron(.none)
                            }
                        }
                    }
                }
                
                if mainVM.animateStatus == .burger || mainVM.animateStatus == .cross {
                    VStack {
                        VStack {
                            ForEach(mainVM.order) { orderDetails in
                                CartCell(mainVM: mainVM, orderDetails: orderDetails) {
                                    orderDetailsIdToCompositionView = orderDetails.id
                                    presentCompositionView = true
                                    print(orderDetails.id)
                                }
                                Divider()
                            }
                            HStack {
                                Text("Total:")
                                    .foregroundColor(.theme.accent)
                                    .font(.system(size: 18, weight: .semibold))
                                Spacer()
                                Text("$\(mainVM.order.total.asNumberString())")
                                    .font(.system(size: 18))
                                    .foregroundColor(.theme.green)
                                    .padding()
                            }
                            
                            HStack {
                                Text("Address:")
                                    .foregroundColor(.theme.accent)
                                    .font(.system(size: 18, weight: .semibold))
                                Spacer()
                                TextField("Enter your address...", text: $mainVM.address)
                                    .focused($focused)
                            }
                        }
                        .padding()
                        
                        CartMapView(address: $mainVM.address)
                        //MapView()
                            .ignoresSafeArea()
                    }
                    .transition(.move(edge: .leading))
                } else if mainVM.animateStatus == .chevron(.none) {
                    CartPaymentView(mainVM: mainVM)
                        .transition(.move(edge: .trailing))
                }
                
            }
            .ignoresSafeArea(edges: .bottom)
        }
        .alert("Address", isPresented: $showAlert) {
            Button("OK") {
                focused = true
            }
        } message: {
            Text("Make sure that you enter your delivery address")
        }
        .onChange(of: presentCompositionView) { bool in
            if !bool {
                mainVM.removeDublicateOrderDetails(at: orderDetailsIdToCompositionView)
            }
        }
        
        if presentCompositionView {
            CompositionView(mainVM: mainVM, mealId: mainVM.order.first(where: { $0.id == orderDetailsIdToCompositionView})?.meal.id ?? -1, orderDetailsId: orderDetailsIdToCompositionView)
                .presentAsBottomSheet($presentCompositionView)
        }
    }
}

struct CartView_Previews: PreviewProvider {
    static var previews: some View {
        CartView(mainVM: MainViewModel())
    }
}
