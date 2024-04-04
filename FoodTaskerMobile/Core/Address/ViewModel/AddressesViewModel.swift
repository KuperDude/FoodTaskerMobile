//
//  AddressesViewModel.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 27.11.2023.
//

import Foundation
import Combine
import SwiftUI

class AddressesViewModel: ObservableObject {
    
    @Published var addresses: [Address] = []
    @ObservedObject var mainVM: MainViewModel
    private let addressDataService = AddressesDataService()
    private var cancellables = Set<AnyCancellable>()
    
    init(mainVM: MainViewModel) {
        self._mainVM = ObservedObject(initialValue: mainVM)
        addSubscribers()
    }
    
    func addSubscribers() {
        
        addressDataService.$savedEntities
            .map(mapAndSortedAddresses)
            .sink { [weak self] returnedAddresses in                
                self?.addresses = returnedAddresses
            }
            .store(in: &cancellables)
    }
    
    private func mapAndSortedAddresses(addresses: [AddressEntity]) -> [Address] {
        addresses.map({ Address(entity: $0) }).sorted(by: { $0.lastUpdateDate > $1.lastUpdateDate })
    }
    
    func updateAddress(address: Address, status: AddressesDataService.Status) {
        addressDataService.updateAddress(address: address, status: status)
        mainVM.address = address
    }
    
    func add(_ address: Address) {
        addressDataService.updateAddress(address: address, status: .add)
        mainVM.address = address
    }
}
