//
//  EditMapView.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 31.07.2023.
//

import SwiftUI

struct EditMapView: View {
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var vm: EditMapViewModel
    @ObservedObject var mainVM: MainViewModel
    @FocusState private var focused: Bool

    @State private var isOn: Bool = false
    
    init(mainVM: MainViewModel) {
        self._vm = ObservedObject(initialValue: EditMapViewModel(mainVM: mainVM))
        self.mainVM = mainVM
    }
    
    //@State private var data = ["Выбрать", "Новый адресс"]
    //@State private var selected: String? = "Выбрать"
    
//    @State private var data1 = ["Квартира", "Дом", "Офис"]
    @State private var presentAddressesView = false
    
    var body: some View {
        ZStack {
            
            //HPicker(data: $data, selected: $selected)
             //   .frame(height: 40)
            
            
//            if selected == "Выбрать" {
//                AddressesView()
//                    .transition(.move(edge: .leading))
//            } else {
                //CartMapView(address: $addre)
            MapView(mapVM: vm.mapVM)
                .ignoresSafeArea()
            
            pinAndBundle
            
            tabBar
            
//            Text(mainVM.address.convertToString())
            AddressView(isOn: $isOn, address: $mainVM.address)
                .presentAsBottomSheet($presentAddressesView)
                .offset(y: presentAddressesView ? 0 : -180)
            
            readyBlock
                
//                HPicker(data: $data1, selected: $selected1)
//                    .frame(height: 40)
                
//                VStack {
//                    addressSection
//
//                    AddNewAddressButton(onTap: {})
//                }
//                .padding()
//                .transition(.move(edge: .trailing))
//            }
            
            
            
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}

struct EditMapView_Previews: PreviewProvider {
    static var previews: some View {
        EditMapView(mainVM: MainViewModel())
    }
}

extension EditMapView {
    
    var addressSection: some View {
        VStack {
            HStack {
                Text("Улица:")
                    .foregroundColor(.theme.accent)
                    .font(.system(size: 18, weight: .semibold))
                Spacer()
                TextField("Enter your address...", text: $mainVM.address.street)
                    .focused($focused)
                
                Text("Дом:")
                    .foregroundColor(.theme.accent)
                    .font(.system(size: 18, weight: .semibold))
                Spacer()
                TextField("Enter your address...", text: $mainVM.address.house)
                    .focused($focused)
            }
            HStack {
                Text("Этаж:")
                    .foregroundColor(.theme.accent)
                    .font(.system(size: 18, weight: .semibold))
                Spacer()
                TextField("Enter your address...", text: $mainVM.address.floor)
                    .focused($focused)
                
                Text("Квартира:")
                    .foregroundColor(.theme.accent)
                    .font(.system(size: 18, weight: .semibold))
                Spacer()
                TextField("Enter your address...", text: $mainVM.address.apartmentNumber)
                    .focused($focused)
            }
        }
    }
    
    var pinAndBundle: some View {
        ZStack {
            //bundle
            if vm.getBundleStatus() == .forbidden || vm.getBundleStatus() == .unknown {
                Text(vm.getBundleStatus().rawValue)
                    .fontWeight(.semibold)
                    .padding(5)
                    .background {
                        RoundedRectangle(cornerRadius: 5)
                            .foregroundColor(.orange)
                    }
                    .offset(y: -50)
            }
            //pin
            Image("pin_customer")
        }
    }
    
    var tabBar: some View {
        VStack {
            
            Spacer()
            
            HStack {
                Spacer()
                VStack(spacing: 5) {
                    ButtonWithImage(imageNamed: "plus", height: 50, action: {
                        vm.plusZoom()
                    })
                    ButtonWithImage(imageNamed: "minus", height: 50, action: {
                        vm.minusZoom()
                    })
                }
            }
            .padding(.trailing, 5)
            .foregroundColor(.theme.background)
            
            Spacer()
            
            HStack {
                ButtonWithImage(imageNamed: "chevron.backward", height: 50, action: {
                    dismiss()
                })
                
                Spacer()
                
                ButtonWithImage(imageNamed: "paperplane.fill", height: 50, action: {
                    vm.moveToUserLocation()
                })
            }
            .padding(.horizontal, 5)
            .foregroundColor(.theme.background)
            
            Rectangle()
                .frame(height: 180)
                .opacity(0.001)
        }
    }
    
    var readyBlock: some View {
        
        VStack {
            Spacer()
            
            ZStack {
                Rectangle()
                    .frame(height: 100)
                    .foregroundColor(.theme.background)
                    .shadow(radius: 5)
                
                Group {
                    RoundedRectangle(cornerRadius: 10)
                        .frame(height: 50)
                        .padding(.horizontal, 15)
                        .padding(.bottom, 10)
                        .foregroundColor(.orange)
                    
                    Text("Готово")
                        .padding(.bottom, 10)
                }
                .opacity(vm.getBundleStatus() == .allowed ? 1 : 0.7)
            }
            .onTapGesture {
                if vm.getBundleStatus() == .allowed {
                    
                }
            }
        }
        .ignoresSafeArea()
        
    }
}
