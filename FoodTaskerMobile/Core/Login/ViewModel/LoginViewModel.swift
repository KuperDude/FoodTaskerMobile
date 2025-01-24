//
//  LoginViewModel.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 27.12.2022.
//

import Foundation
import Combine

class LoginViewModel: ObservableObject {
    var authService: AuthManager
    @Published var user: User?
    var cancellables = Set<AnyCancellable>()
    
    @Published var username: String = ""
    @Published var mail: String = ""
    
    @Published var password1: String = ""
    @Published var password2: String = ""
    
    @Published var alertStatus: AlertStatus?
    @Published var customErrorDescription: String?
    
    enum AlertStatus: String {
        case noEqualPassword = "Пароли не совпадают!"
        case smallPassword   = "Пароль должен содержать не менее 8 символов!"
        case usernameIsEmpty = "Введите имя пользователя!"
        case noExistMail     = "Данной почты не существует!"
        case noCurrectMailOrPassword   = "Введите почту и пароль!"
        case custom = ""
    }
    
    func errorText(_ status: AlertStatus?) -> String? {
        guard let status = status else { return nil }
        switch status {
        case .custom: return customErrorDescription
        default: return status.rawValue
        }
    }
    
    init(user: User?) {
        self.user = user
        self.authService = AuthManager.instance
        
        addPublishers()
    }
    
    private func addPublishers() {
        authService.$user
            .receive(on: DispatchQueue.main)
            .sink { [weak self] data in
                guard let user = data else { return }
                if APIManager.instance.accessToken != "" {
                    self?.user = user                    
                } else if user.id == "Anonymous" {
                    self?.user = user
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - User Intents
    func wakeUpSession(_ method: AuthManager.RegistrationMethod, isAlreadyLogin: Bool = false) async -> Bool {
        //do {
            
        try? await authService.wakeUpSession(method: method, isAlreadyLogin: isAlreadyLogin)
            
        if isAlreadyLogin {
            guard let result: Bool = try? await authService.handleAuthorization(method: method) else {
                return false
            }
            
            if method == .google && result {
                self.user = authService.user
            }
        }
        
        return user != nil
    }
    
    func loginOnMail() {
        authService.login(mail: mail, password: password1) { [weak self] error in
            if error != nil {
                self?.customErrorDescription = error
                self?.alertStatus = .custom
            }
        }
    }
    
    func register() {
        authService.register(username: username, mail: mail, password: password1) { [weak self] error in
            if error != nil {
                self?.customErrorDescription = error
                self?.alertStatus = .custom
            }
        }
    }

    func checkCurrectData() -> Bool {
        if password1.count < 8 || password2.count < 8 {
            alertStatus = .smallPassword
            return false
        }
        if password1 != password2 {
            alertStatus = .noEqualPassword
            return false
        }
        if username.isEmpty || !checkCurrectUsername() {
            alertStatus = .usernameIsEmpty
            return false
        }
        
        return true
    }
    
    func checkCurrectDataOnLogin() -> Bool {
        if password1.count < 8 || mail.count == 0 {
            alertStatus = .noCurrectMailOrPassword
            return false
        }
        return true
    }
    
    private func checkCurrectUsername() -> Bool {
        for i in username {
            if i != " " {
                return true
            }
        }
        return false
    }
}
