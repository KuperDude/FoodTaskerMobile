//
//  MealService.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 01.01.2023.
//

import Foundation
import Combine

class MealService {
    
    @Published var meals = [Meal]()
    
    private var mealSubscription: AnyCancellable?
    
    init() {
        fetchMeals()
    }
    
    func fetchMeals() {
        mealSubscription = APIManager.instance.getMealsPublisher()
            .sink(receiveCompletion: { result in
                switch result {
                case .finished: break
                case .failure(let error): print(error)
                }
            }, receiveValue: { [weak self] returnedMeals in              
                self?.meals = returnedMeals
            })
    }
}

