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
    @State var address = Address()
    @State var bundleStatus: MapViewModel.BundleStatus = .scrolled
    @State var refresh = true
    
    var onTapReady: (Address)->Void
    
    @State var buttonMinusFrame: CGRect = .zero
    
    let pub = NotificationCenter.default
                .publisher(for: NSNotification.Name("OffsetYChange"))
    let offsetYAddressView: CGFloat = 210
                
    @State var offsetOfAddressView: CGFloat = .zero
    
    init(address: Address, addressesVM: AddressesViewModel, onTapReady: @escaping (Address)->Void) {
        self.onTapReady = onTapReady
        self._vm = ObservedObject(initialValue: EditMapViewModel(address: address, addressesVM: addressesVM))
        self._address = State(initialValue: address)
    }
    
    //@State private var data = ["Выбрать", "Новый адресс"]
    //@State private var selected: String? = "Выбрать"
    
//    @State private var data1 = ["Квартира", "Дом", "Офис"]
    @State private var presentAddressView = false
    
    var body: some View {
        ZStack {
            
            //HPicker(data: $data, selected: $selected)
             //   .frame(height: 40)
            
            
//            if selected == "Выбрать" {
//                AddressesView()
//                    .transition(.move(edge: .leading))
//            } else {
                //CartMapView(address: $addres)
            
            if refresh {
                MapView(mapVM: vm.mapVM)
                    .ignoresSafeArea()
            } else {
                MapView(mapVM: vm.mapVM)
                    .ignoresSafeArea()
            }
            
//            pinAndBundle
            
            tabBar
            
//            Text(mainVM.address.convertToString())
            AddressView(address: $address)
                .presentAsBottomSheet($presentAddressView, maxHeight: (UIScreen.main.bounds.height) - buttonMinusFrame.minY, offsetY: offsetYAddressView, isAllowPresent: bundleStatus == .allowed || address.isStreetAndHouseFill)
                .offset(y: presentAddressView ? 0 : -offsetYAddressView)
            
            //if presentAddressView {
                crossButton
            //}
            
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
        .ignoresSafeArea()
        .onReceive(pub) { offsetY in
            guard 
                let y = offsetY.object as? CGFloat,
                vm.getBundleStatus() == .allowed
            else { return }
//            print(y)
            offsetOfAddressView = y
            
        }
        .onChange(of: presentAddressView, perform: { newValue in
            if newValue {
                vm.addAddress(address)
            } else {
                //vm.addAddress(address)
                vm.mapVM = MapViewModel(address: address)
                refresh.toggle()
            }
        })
//        .sheet(isPresented: .constant(true), content: {
//            AddressView(address: $address)
//        })
        .onReceive(vm.mapVM.$address, perform: { newAddress in
            if !presentAddressView {
                let id = self.address.id
                var nAddress = newAddress
                nAddress.id = id
                self.address = nAddress
            }
        })
        .onReceive(vm.mapVM.$bundleStatus, perform: { bundleStatus in
            self.bundleStatus = bundleStatus
        })
    }
}

struct EditMapView_Previews: PreviewProvider {
    static var previews: some View {
        EditMapView(address: Address(), addressesVM: AddressesViewModel(mainVM: MainViewModel()), onTapReady: {_ in })
    }
}

extension EditMapView {
    
//    var pinAndBundle: some View {
//        ZStack {
//            //bundle
//            if bundleStatus == .forbidden || bundleStatus == .unknown {
//                Text(bundleStatus.rawValue)
//                    .fontWeight(.semibold)
//                    .padding(5)
//                    .background {
//                        RoundedRectangle(cornerRadius: 5)
//                            .foregroundColor(.orange)
//                    }
//                    .offset(y: -75)
//            }
//            //pin
//            ZStack {
//                MapTrackingAnimationView(isScrolling: $bundleStatus)
//                    .frame(width: 200, height: 200)
//                    .allowsHitTesting(false)
//                    .padding(.bottom, 50)
//                Circle()
//                    .frame(width: 5, height: 5)
//                    .foregroundStyle(.red)
//                    .opacity(bundleStatus == .scrolled ? 1.0 : 0.0)
//            }
//        }
//        .ignoresSafeArea(.keyboard)
//    }
    
    var tabBar: some View {
        VStack {
            
            Spacer()
            
            HStack {
                Spacer()
                VStack(spacing: 5) {
                    ButtonMenuStaticView(status: .plus, height: 50) {
                        vm.plusZoom()
                    }
//                    ButtonWithImage(imageNamed: "plus", height: 50, action: {
//                        vm.plusZoom()
//                    })
                    
                    GeometryReader { geo in
                        ButtonMenuStaticView(status: .minus, height: 50) {
                            vm.minusZoom()
                        }
                        .preference(key: FramePreferenceKey.self, value: geo.frame(in: .global))
                    }
                    .onPreferenceChange(FramePreferenceKey.self) { frame in
                        buttonMinusFrame = frame
                    }
                    .frame(width: 50, height: 50)
                }
            }
            .padding(.trailing, 5)
            .foregroundColor(.theme.background)
            
            Spacer()
            
            HStack {
                ButtonMenuStaticView(status: .chevron, height: 50) {
                    vm.addAddress(address)
                    onTapReady(address)
                    dismiss()
                }
                
                Spacer()
                
                ButtonWithImage(imageNamed: "paperplane.fill", height: 50, action: {
                    vm.moveToUserLocation()
                })
//                ButtonMenuStaticView(status: .minus, height: 50, action: {
//                    vm.moveToUserLocation()
//                })
            }
            .padding(.horizontal, 5)
            .foregroundColor(.theme.background)
            
            Rectangle()
                .frame(height: offsetYAddressView)
                .opacity(0.001)
        }
    }
    
    var crossButton: some View {
        VStack {
            HStack {
                AnimatedCrossView(offsetY: $offsetOfAddressView, maxOffsetY: (UIScreen.main.bounds.height) - buttonMinusFrame.minY - offsetYAddressView, height: 50, action: {
                    if presentAddressView {
                        presentAddressView = false
                        offsetOfAddressView = .zero
                    } else {
                        vm.plusZoom()
                    }
                })
                //.animation(.spring(), value: presentAddressesView)
                .offset(x: buttonMinusFrame.minX, y: buttonMinusFrame.minY - buttonMinusFrame.height - 5)
                Spacer()
            }
            Spacer()
        }
        .ignoresSafeArea()
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
                .opacity(vm.getBundleStatus() == .allowed || address.isStreetAndHouseFill ? 1 : 0.7)
            }
            .onTapGesture {
                if vm.getBundleStatus() == .allowed || address.isStreetAndHouseFill {
//                    guard let address = address else {
//                        dismiss()
//                        return
//                    }
                    vm.addAddress(address)
                    onTapReady(address)
                    dismiss()
                }
            }
        }
        .ignoresSafeArea()
        
    }
}
