//
//  ProfileViewModel.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 22.04.2024.
//

import Foundation

class ProfileViewModel: ObservableObject {
    var authService: AuthManager
    
    @Published var alertStatus: AlertStatus?
    @Published var customErrorDescription: String?
    
    init() {
        authService = AuthManager.instance
    }
    
    enum AlertStatus: String {
        case custom = ""
    }
    
    func errorText(_ status: AlertStatus?) -> String? {
        guard let status = status else { return nil }
        switch status {
        case .custom: return customErrorDescription
        }
    }
    
    // MARK: - UserIntents
    
    func delete(completion: @escaping () -> Void) {
        if APIManager.instance.accessToken == "someuser@gmail.com" {
            customErrorDescription = "Тестовый аккаунт не может быть удалён"
            alertStatus = .custom
            return
        }
        
        authService.deleteAccount { [weak self] error in
            if error != nil {
                self?.customErrorDescription = error
                self?.alertStatus = .custom
            } else {
                completion()
            }
        }
    }
}
