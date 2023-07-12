//
//  MealCellViewModel.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 01.01.2023.
//

import SwiftUI
import Combine

class MealCellViewModel: ObservableObject {
    
    @Published var image: UIImage?
    @Published var isLoading = false

    private let dataService: MealImageService
    private var cancellables = Set<AnyCancellable>()
    
    init(meal: Meal) {
        self.dataService = MealImageService(meal: meal)
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
}
