//
//  RestaurantViewModel.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 29.12.2022.
//

import Foundation
import Combine

class RestaurantViewModel: ObservableObject {
    
    @Published var meals = [Meal]()
    @Published var mealSections = [String: [Meal]]()
    @Published var sections = [String]()
    @Published var selectedSection: String?
    @Published var mealsIsLoading = true
    
    @Published var restaurants = [Restaurant]()
    @Published var searchText = ""
    @Published var selectedRestaurantId: Int?
    @Published var category: String?
    
    private let restaurantService = RestaurantService()
    private var mealService: MealService = MealService()
    
    private var mealSubscription: AnyCancellable?
    var cancellables = Set<AnyCancellable>()
    
    
    
    init() {
        addPublishers()
    }
    
    func addPublishers() {
        
        //updates restaurants
        $searchText
            .combineLatest(restaurantService.$restaurants)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(filterRestaurants)
            .sink { [weak self] returnedRestaurants in
                self?.restaurants = returnedRestaurants
            }
            .store(in: &cancellables)
        
        restaurantService.$restaurants
            .receive(on: DispatchQueue.main)
            .sink { [weak self] restaurants in
                self?.restaurants = restaurants
            }
            .store(in: &cancellables)
        
        mealService.$meals
            .receive(on: DispatchQueue.main)
            .sink { [weak self] meals in
                self?.meals = meals
                self?.sortMealToSection()
                self?.sections = self?.mealSections.keys.sorted() ?? []
                self?.mealsIsLoading = false
            }
            .store(in: &cancellables)
        
//        $selectedRestaurantId
//            .receive(on: DispatchQueue.main)
//            .sink { id in
//                self.mealsIsLoading = true
//                guard let id = id else {
//                    self.mealSubscription?.cancel()
//                    return
//                }
//
//                self.mealService = MealService(restaurantId: id)
//                self.mealSubscription = self.mealService?.$meals
//                    .dropFirst()
//                    .receive(on: DispatchQueue.main)
//                    .sink { [weak self] returnedMeals in
//                        self?.meals = returnedMeals
//                        self?.mealsIsLoading = false
//                    }
//            }
//            .store(in: &cancellables)

    }
    
    private func sortMealToSection() {
        for meal in meals {
            mealSections[meal.category.name] = (mealSections[meal.category.name] ?? []) + [meal]
        }
    }
    
    private func filterRestaurants(text: String, restaurants: [Restaurant]) -> [Restaurant] {
        guard !text.isEmpty else {
            return restaurants
        }
        
        let lowercasedText = text.lowercased()
        
        return restaurants.filter { restaurant in
            restaurant.name.lowercased().contains(lowercasedText)
        }
    }
    
    func getRestaurantName() -> String {
        return restaurants.first(where: { $0.id == selectedRestaurantId })?.name ?? ""
    }
    
    func restaurantTitles() -> [String] {
        return restaurants.map { $0.name }
    }
    
    func getMeals(at category: String) -> [Meal] {
        return mealSections[category] ?? []
    }
    
    func getMeal(at id: Int) -> Meal? {
        return meals.first(where: { $0.id == id })
    }
    
}
