//
//  DeliveryView.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 17.12.2022.
//

import SwiftUI
import MapKit

struct DeliveryView: View {
    @ObservedObject var mainVM: MainViewModel
    @StateObject var vm = DeliveryViewModel()
    var deliveryStatus: [DeliveryViewModel.Status] = [.accepted, .ready, .onTheWay, .delivered]
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
                
                VStack(spacing: 0) {
                    ForEach(deliveryStatus, id: \.self) { status in
                        DeliveryCell(text: status.rawValue, check: vm.isCheck(status))
                        
                        if status != .delivered {
                            DeliveryProgressAnimatedView(status: status, currentStatus: vm.status)
                        }
                    }
                }
                
                .padding()
                .padding(.leading, 40)
                
                if vm.status == .accepted || vm.status == .ready {
                    CookingAnimationView()
                        .frame(width: 300, height: 300)
                        .padding(.top, -100)
                } else if vm.status == .onTheWay {
                    DeliveryAnimationView()
                        .frame(width: 300, height: 200)
                        .padding(.top, -100)
                }
                
                Divider()
                
                if vm.ordersInfo.isEmpty {
                    Text("Ваш список заказов пуст")
                        .font(.headline)
                        .fontWidth(.compressed)
                        .foregroundStyle(Color.theme.secondaryText)
                        .padding()
                    
                    SadSmileAnimationView()
                        .frame(width: 200, height: 200)
                } else {
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], content: {
                            Group {
                                Text("Дата")
                                Text("Статус")
                                Text("Сумма")
                            }
                            .font(.title2)
                            .fontWidth(.compressed)
                        })
                        
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], content: {
                            ForEach(vm.ordersInfo) { orderInfo in
                                Text(orderInfo.date.dateFromWebtoApp())
                                Text(orderInfo.status)
                                    .foregroundStyle(vm.statusColor(orderInfo.status))
                                Text(orderInfo.total.asCurrencyWith2Decimals())
                            }
                            .padding(.vertical, 5)
                            .font(.callout)
                            .fontWidth(.condensed)
                        })
                    }
                }
                
                Spacer()
            }
            .ignoresSafeArea(edges: .bottom)
        }
    }
}

struct DeliveryView_Previews: PreviewProvider {
    static var previews: some View {
        DeliveryView(mainVM: MainViewModel())
    }
}
