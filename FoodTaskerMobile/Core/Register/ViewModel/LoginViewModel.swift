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
    
    @Published var login: String = ""
    @Published var mail: String = ""
    
    @Published var password1: String = ""
    @Published var password2: String = ""
    
    init(user: User?) {
        self.user = user
        self.authService = AuthService.instance
        
        addPublishers()
    }
    
    private func addPublishers() {
        authService.$user
            .sink { [weak self] data in
                if let user = data {                    
                    self?.user = user
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - User Intents
    func wakeUpSession(_ method: AuthService.RegistrationMethod) {
        authService.wakeUpSession(method: method)
    }
    
    func loginOnMail() {
        authService.login(mail: mail)
    }
}
