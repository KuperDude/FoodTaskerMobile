//
//  LoginViewModel.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 27.12.2022.
//

import Foundation
import Combine

class LoginViewModel: ObservableObject {
    var authService: AuthService
    @Published var user: User?
    var cancellables = Set<AnyCancellable>()
    
    init(user: User?) {
        self.user = user
        self.authService = AuthService.instance
        
        addPublishers()
    }
    
    private func addPublishers() {
        authService.$user
            .sink { [weak self] data in
                if let user = data {
                    UserDefaults.standard.set(user.fullName, forKey: "fullName")
                    self?.user = user
                }
            }
            .store(in: &cancellables)
    }
    
    func getButtonTitle() -> String {
        if let fullName = UserDefaults.standard.string(forKey: "fullName") {
            return "Continue as \(fullName)"
        } else {
            return "Login with VK"
        }
    }
    
    // MARK: - User Intents
    func wakeUpSession() {
        authService.wakeUpSession()
    }
}
