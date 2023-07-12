//
//  CompositionCellViewModel.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 13.06.2023.
//

import Foundation
import Combine
import SwiftUI

class CompositionCellViewModel: ObservableObject {
    
    @Published var image: UIImage?
    @Published var isLoading = false
    
    private let dataService: IngredientImageService
    private var cancellables = Set<AnyCancellable>()
    
    init(ingredient: Ingredient) {
        self.dataService = IngredientImageService(ingredient: ingredient)
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
