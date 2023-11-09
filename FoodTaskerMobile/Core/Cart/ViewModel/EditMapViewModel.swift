//
//  EditMapViewModel.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 04.10.2023.
//

import Foundation
import SwiftUI

class EditMapViewModel: ObservableObject {
    @ObservedObject var mapVM: MapViewModel
    
    init(mainVM: MainViewModel) {
        self._mapVM = ObservedObject(initialValue: MapViewModel(mainVM: mainVM))
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
