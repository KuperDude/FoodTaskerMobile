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
    @State private var isOpenKeyboard = false
    
    @FocusState var focusedField: AddressView.Field?
    
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

    @State private var presentAddressView = false
    
    var body: some View {
        ZStack {
                
            if refresh {
                MapView(mapVM: vm.mapVM)
                    .ignoresSafeArea()
            } else {
                MapView(mapVM: vm.mapVM)
                    .ignoresSafeArea()
            }
                            
            tabBar
            
            AddressView(address: $address, focusedField: $focusedField)
                .presentAsBottomSheet($presentAddressView, maxHeight: isOpenKeyboard ? (UIScreen.main.bounds.height) - buttonMinusFrame.minY + 150 : (UIScreen.main.bounds.height) - buttonMinusFrame.minY, offsetY: offsetYAddressView, isAllowPresent: bundleStatus == .allowed || address.isStreetAndHouseFill)
                .offset(y: presentAddressView ? 0 : -offsetYAddressView)
                .onKeyboardAppear { bool in
                    withAnimation(.spring) {
                        isOpenKeyboard = bool
                    }
                }
            
            crossButton
            
            if focusedField != nil {
                Rectangle()
                    .ignoresSafeArea()
                    .opacity(0.01)
                    .onTapGesture {
                        focusedField = nil
                    }
            }
            
            readyBlock
            
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .ignoresSafeArea()
        .onReceive(pub) { offsetY in
            guard 
                let y = offsetY.object as? CGFloat,
                vm.getBundleStatus() == .allowed
            else { return }
            offsetOfAddressView = y
            
        }
        .onChange(of: presentAddressView, perform: { newValue in
            if newValue {
                vm.addAddress(address)
            } else {
                offsetOfAddressView = .zero
                vm.mapVM = MapViewModel(address: address)
                refresh.toggle()
            }
        })
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
    
    var tabBar: some View {
        VStack {
            
            Spacer()
            
            HStack {
                Spacer()
                VStack(spacing: 5) {
                    ButtonMenuStaticView(status: .plus, height: 50) {
                        vm.plusZoom()
                    }
                    .opacity(presentAddressView ? 0 : 1)
                    
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
                    if address.isStreetAndHouseFill {
                        vm.addAddress(address)
                        onTapReady(address)
                    }
                    dismiss()
                }
                
                Spacer()
                
                ButtonWithImage(imageNamed: "paperplane.fill", height: 50, action: {
                    vm.moveToUserLocation()
                })
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
                    } else {
                        vm.plusZoom()
                    }
                })
                .offset(x: buttonMinusFrame.minX, y: buttonMinusFrame.minY - buttonMinusFrame.height - 5)
                .offset(y: isOpenKeyboard ? -150 : 0)
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
                if (vm.getBundleStatus() == .allowed || address.isStreetAndHouseFill) && presentAddressView {
                    vm.addAddress(address)
                    onTapReady(address)
                    dismiss()
                } else if !presentAddressView {
                    presentAddressView = true
                }
            }
        }
        .ignoresSafeArea()
        
    }
}
