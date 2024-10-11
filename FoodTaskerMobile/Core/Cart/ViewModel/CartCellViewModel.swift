//
//  CartCellViewModel.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 05.01.2023.
//

import SwiftUI

class CartCellViewModel: ObservableObject {
    @ObservedObject var mainVM: MainViewModel
    
    var orderDelails: OrderDetails
    
    
    init(mainVM: MainViewModel, orderDelails: OrderDetails) {
        self._mainVM = ObservedObject(wrappedValue: mainVM)
        self.orderDelails = orderDelails
    }
    
    //MARK: - User Intents
    func change(quantity: Int) {
        guard let index = mainVM.order.firstIndex(where: { $0.id == orderDelails.id }) else { return }
        
        switch quantity {
        case 0: mainVM.removeOrderDetails(at: index)
        default: mainVM.order[index] = orderDelails.change(quantity: quantity)
        }
        
    }
}
