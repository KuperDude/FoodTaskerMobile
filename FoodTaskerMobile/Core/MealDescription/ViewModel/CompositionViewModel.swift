//
//  CompositionViewModel.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 25.05.2023.
//

import Foundation
import SwiftUI
import Combine

class CompositionViewModel: ObservableObject {
    var mainVM: MainViewModel
    private let orderDetailsId: UUID?
    private let gotenIngredients: [Ingredient]?
    
    private var ingredientsService: IngredientsService
    
    private var cancellables = Set<AnyCancellable>()
    
    @Published var ingredients: [Ingredient] = []
    
    init(mainVM: MainViewModel, mealId: Int, orderDetailsId: UUID?, gotenIngredients: [Ingredient]?) {
        self.mainVM = mainVM
        self.orderDetailsId = orderDetailsId
        self.gotenIngredients = gotenIngredients
        self.ingredientsService = IngredientsService(mealId: mealId)
        
        getIngredients()
        addPublishers()
    }
    
    private func getIngredients() {
        if (gotenIngredients?.isEmpty ?? true) && (mainVM.order.first(where: { $0.id == orderDetailsId })?.ingredients.isEmpty ?? true) {
            ingredientsService.$ingredients
                .receive(on: DispatchQueue.main)
                .sink { [weak self] returnedingredients in
                    self?.ingredients = returnedingredients
                }
                .store(in: &cancellables)
        } else if let gotenIngredients = gotenIngredients {
            ingredients = gotenIngredients
        } else if let orderIngredients = mainVM.order.first(where: { $0.id == orderDetailsId })?.ingredients {
            ingredients = orderIngredients
        }
    }
    
    func addPublishers() {
        $ingredients
            .sink { [weak self] ingredients in
                self?.mainVM.changeIngredients(to: self?.orderDetailsId, ingredients: ingredients)
            }
            .store(in: &cancellables)
    }

}











