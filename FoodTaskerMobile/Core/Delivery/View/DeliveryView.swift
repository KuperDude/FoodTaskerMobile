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
    var deliveryStatus: [DeliveryViewModel.Status] = [.accepted, .ready, .onTheWay]
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
                }

                VStack {
                    ForEach(deliveryStatus, id: \.self) { status in
                        DeliveryCell(text: status.rawValue, check: vm.isCheck(status))
                    }
                }
                .padding()
                .padding(.leading, 40)
                
                ZStack {
                    // background
                    DeliveryMapView()
                        .ignoresSafeArea()
                    
                    //content
                    VStack {
                        Spacer()
                        
                        CourierView()
                            .padding()
                            .padding(.bottom, 20)
                    }
                }

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
