//
//  MealViewModel.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 29.12.2022.
//

import Foundation
import Combine

class MealViewModel: ObservableObject {
    
    @Published var meals = [Meal]()
    @Published var mealSections = [Category: [Meal]]()
    @Published var sections = [String]()
    @Published var selectedSection: String?
    @Published var mealsIsLoading = true
    
    @Published var searchText = ""
    @Published var category: String?
    
    private var mealService: MealService = MealService()
    
    private var mealSubscription: AnyCancellable?
    var cancellables = Set<AnyCancellable>()

    init() {
        addPublishers()
    }
    
    func addPublishers() {
        
        $searchText
            .combineLatest(mealService.$meals)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(filterMeals)
            .sink { [weak self] returnedMeals in
                self?.mealSections = [:]
                self?.sortMealToSection(returnedMeals)
                self?.sections = self?.mealSections.keys.sorted(by: { $0.order < $1.order }).map({ $0.name }) ?? []
            }
            .store(in: &cancellables)
        
        mealService.$meals
            .receive(on: DispatchQueue.main)
            .sink { [weak self] meals in
                self?.meals = meals
                self?.sortMealToSection(meals)
                self?.sections = self?.mealSections.keys.sorted(by: { $0.order < $1.order }).map({ $0.name }) ?? []
                self?.mealsIsLoading = false
            }
            .store(in: &cancellables)

    }
    
    private func sortMealToSection(_ meals: [Meal]) {
        for meal in meals {
            mealSections[meal.category] = (mealSections[meal.category] ?? []) + [meal]
        }
    }
    
    private func filterMeals(text: String, meals: [Meal]) -> [Meal] {
        guard !text.isEmpty else {
            return meals
        }
        
        let lowercasedText = text.lowercased()
        
        return meals.filter { meal in
            meal.name.lowercased().contains(lowercasedText)
        }
    }
    
    func getMeals(at category: String) -> [Meal] {
        guard
            let cat = mealSections.keys.first(where: { $0.name == category }),
            let meals = mealSections[cat] else {
            return []
        }
        return meals
    }
    
    func getMeal(at id: Int) -> Meal? {
        return meals.first(where: { $0.id == id })
    }
    
}
