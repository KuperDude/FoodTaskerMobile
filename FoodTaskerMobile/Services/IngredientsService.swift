//
//  IngredientsService.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 11.06.2023.
//

import Foundation
import Combine

class IngredientsService {
    
    @Published var ingredients = [Ingredient]()
    
    private var mealSubscription: AnyCancellable?
    
    let mealId: Int
    
    init(mealId: Int) {
        self.mealId = mealId
        fetchIngredients()
    }
    
    func fetchIngredients() {
        mealSubscription = APIManager.instance.getIngredientsPublisher(at: mealId)
            .sink(receiveCompletion: { result in
                switch result {
                case .finished: break
                case .failure(let error): print(error)
                }
            }, receiveValue: { [weak self] returnedIngredients in
                self?.ingredients = returnedIngredients
            })
    }
}
