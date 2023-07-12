//
//  CartCellViewModel.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 05.01.2023.
//

import SwiftUI
import Combine

class CartCellViewModel: ObservableObject {
    @ObservedObject var mainVM: MainViewModel
    @Published var image: UIImage?
    @Published var isLoading = false
    
    var orderDelails: OrderDetails
    
    private let dataService: MealImageService
    private var cancellables = Set<AnyCancellable>()
    
    
    init(mainVM: MainViewModel, orderDelails: OrderDetails) {
        self._mainVM = ObservedObject(wrappedValue: mainVM)
        self.orderDelails = orderDelails
        self.dataService = MealImageService(meal: orderDelails.meal)
        
        self.isLoading = true
        getImage()
    }
    
    private func getImage() {
        dataService.$image
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.isLoading = false
            } receiveValue: { [weak self] returnedImage in
                self?.isLoading = false
                self?.image = returnedImage
            }
            .store(in: &cancellables)

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
