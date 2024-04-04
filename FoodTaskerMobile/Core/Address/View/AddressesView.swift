//
//  AddressView.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 22.07.2023.
//

import SwiftUI

struct AddressesView: View {
    
    @ObservedObject var vm: AddressesViewModel
    @Binding var presentAddressesView: Bool
    
    @State private var isButtonPressed = false
    @State private var address: Address?
    @ObservedObject var mainVM: MainViewModel
    
    init(presentAddressesView: Binding<Bool>, mainVM: MainViewModel) {
        self._vm = ObservedObject(initialValue: AddressesViewModel(mainVM: mainVM))
        self._presentAddressesView = presentAddressesView
        self.mainVM = mainVM
    }
    
    var body: some View {
        VStack {
            VStack {
                ScrollView {
                    ForEach(vm.addresses) { address in                        
                        AddressCell(mainAddress: $mainVM.address, address: address, settingsAction: {
                            self.address = address
                        })
                    }
                }
                
                Spacer()
                
                AddNewAddressButton(onTap: {
                    isButtonPressed = true
                })
            }
            .padding(.vertical)
            .padding(.bottom, 15)
            .fullScreenCover(item: $address, content: { address in
                EditMapView(address: address, addressesVM: vm) { newAddress in
                    mainVM.address = newAddress
                    presentAddressesView = false
                }
            })
            .fullScreenCover(isPresented: $isButtonPressed) {
                EditMapView(address: Address(), addressesVM: vm) { newAddress in
                    mainVM.address = newAddress
                    presentAddressesView = false
                }
            }
        }
    }
}

struct AddressesView_Previews: PreviewProvider {
    static var previews: some View {
        AddressesView(presentAddressesView: .constant(true), mainVM: MainViewModel())
    }
}
