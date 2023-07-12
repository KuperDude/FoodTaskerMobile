//
//  RestaurantCellViewModel.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 31.12.2022.
//

import SwiftUI
import Combine

class RestaurantCellViewModel: ObservableObject {
    
    @Published var image: UIImage?
    @Published var isLoading = false
    
    private let dataService: RestaurantImageService
    private var cancellables = Set<AnyCancellable>()
    
    init(restaurant: Restaurant) {
        self.dataService = RestaurantImageService(restaurant: restaurant)
        getImage()
        self.isLoading = true
    }
    
    private func getImage() {
        dataService.$image
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.isLoading = false
            } receiveValue: { [weak self] returnedImage in
                self?.image = returnedImage
            }
            .store(in: &cancellables)

    }
}
