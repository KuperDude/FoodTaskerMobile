//
//  RestaurantService.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 29.12.2022.
//

import Foundation
import Combine

class RestaurantService {
    
    @Published var restaurants = [Restaurant]()
    
    private var restaurantSubscription: AnyCancellable?
    
    init() {
        fetchRestaurants()
    }
    
    func fetchRestaurants() {
        restaurantSubscription = APIManager.instance.getRestaurantsPublisher()
            .sink(receiveCompletion: { result in
                switch result {
                case .finished: break
                case .failure(let error): print(error)
                }
            }, receiveValue: { [weak self] restaurants in
                self?.restaurants = restaurants
            })
    }
}
