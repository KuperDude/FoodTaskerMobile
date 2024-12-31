//
//  EditMapViewModel.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 04.10.2023.
//

import Foundation
import SwiftUI
import Combine

class EditMapViewModel: ObservableObject {
    @ObservedObject var mapVM: MapViewModel
    @ObservedObject var addressesVM: AddressesViewModel
    
    var cancellables = Set<AnyCancellable>()
    
    init(address: Address, addressesVM: AddressesViewModel) {
        self._addressesVM = ObservedObject(initialValue: addressesVM)
        self._mapVM = ObservedObject(initialValue: MapViewModel(address: address))
    }
    
    func getBundleStatus() -> MapViewModel.BundleStatus {
        mapVM.bundleStatus
    }
    
    func plusZoom() {
        mapVM.plusZoom()
    }
    func minusZoom() {
        mapVM.minusZoom()
    }
    
    func moveToUserLocation() {
        mapVM.moveToUserLocation()
    }
}
