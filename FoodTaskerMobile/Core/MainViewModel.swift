//
//  MainViewModel.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 08.02.2023.
//

import Foundation
import SwiftUI

class MainViewModel: ObservableObject {
    @Published var user: User?
    @Published var order = [OrderDetails]()
    @Published var deliveryPrice: Float = 0
    @Published var animateStatus: Status = .burger
    @Published var currentCategory: Category = .menu
    @Published var address: Address = Address()
    @Published var restaurantTitle: String?
    
    init(user: User? = nil, order: [OrderDetails] = [OrderDetails](), animateStatus: Status = .burger, currentCategory: Category = .menu, address: Address = Address(), restaurantTitle: String? = nil) {
        self.user = user
        self.order = order
        self.animateStatus = animateStatus
        self.currentCategory = currentCategory
        self.address = address
        self.restaurantTitle = restaurantTitle
    }
    
    func isUserAnonymous() -> Bool {
        user?.id == "Anonymous"
    }
    
    func moveToLoginView() {
        AuthManager.instance.user = nil
        user = nil
        currentCategory = .menu
        animateStatus = .burger
    }
}

// MARK: - User Intents
extension MainViewModel {
    
    func changeIngredients(to orderDetailsId: UUID?, ingredients: [Ingredient]) {        
        guard
            let orderDetailsId = orderDetailsId,
            let index = order.firstIndex(where: { $0.id == orderDetailsId })
        else { return }
        
        if order[index].ingredients != ingredients {            
            order[index] = order[index].change(ingredients: ingredients)
        }
    }
    
    func removeDublicateOrderDetails(at orderId: UUID?) {
        guard
            let id = orderId,
            let index = order.firstIndex(where: { $0.id == id })
        else { return }
        
        for i in order.indices {
            if i != index && order[i] == order[index] {
                changeQuantity(at: i, quantity: order[i].quantity + order[index].quantity)
                order.remove(at: index)
                return
            }
        }
    }
    
    func changeQuantity(at index: Int, quantity: Int) {
        order[index] = order[index].change(quantity: quantity)
    }
    
    func removeOrderDetails(at index: Int) {
        order.remove(at: index)
    }
    
    func total() -> Float {
        order.total + deliveryPrice
    }
}

// MARK: - Category
extension MainViewModel {
    enum Category: Int, CaseIterable, Identifiable {
        case profile
        case menu
        case cart
        case delivery
        case logout
        
        var id: Int {
            self.rawValue
        }
        
        var iconName: String {
            switch self {
            case .profile: return "icon_restaurants"
            case .menu: return "icon_restaurants"
            case .cart: return "icon_cart"
            case .delivery: return "icon_delivery"
            case .logout: return "icon_logout"
            }
            
        }
        
        var text: String {
            switch self {
            case .profile: return ""
            case .menu: return "МЕНЮ"
            case .cart: return "КОРЗИНА"
            case .delivery: return "ДОСТАВКА"
            case .logout: return "ВЫЙТИ"
            }
        }
    }
}

//MARK: - Status
extension MainViewModel {
    enum Status: Equatable {
        case burger
        case chevron(ChevronStatus)
        case cross
        
        var topDegrees: Angle {
            switch self {
            case .burger: return .degrees(0)
            case .cross: return .degrees(48)
            case .chevron: return .degrees(-24)
            }
        }
        
        var bottomDegrees: Angle {
            switch self {
            case .burger: return topDegrees
            case .cross: return -topDegrees
            case .chevron: return -topDegrees
            }
        }
        
        enum ChevronStatus: Equatable {
            case mealDetails(id: Int)
            case addressDetails
            case none
        }
        
        var getChevronIdOrMinusOne: Int {
            switch self {
            case .chevron(.mealDetails(id: let id)): return id
            default: return -1
            }
        }
        
        mutating func newStatusOnTap() {
            switch self {
            case .burger:                     self = .cross
            case .chevron(.mealDetails(id: _)): self = .burger
            case .cross:                        self = .burger
            case .chevron(.none):               self = .burger
            case .chevron(.addressDetails):     self = .burger
            }
        }
    }
}
