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
    
    @Published var code: Int?
    
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
        self.authService = AuthService.instance
        
        addPublishers()
    }
    
    private func addPublishers() {
        authService.$user
            .receive(on: DispatchQueue.main)
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
    
    func alreadyLoginSession(_ method: AuthService.RegistrationMethod) {
        authService.alreadyLoginSession(method: method)
    }
    
    func loginOnMail() {
        authService.login(mail: mail, password: password1) { [weak self] error in
            if error != nil {
                self?.customErrorDescription = error
                self?.alertStatus = .custom
            }
        }
    }
    
    func sendCode() {
        authService.sendCode(mail: mail) { [weak self] code, error in
            if error != nil {
                self?.customErrorDescription = error
                self?.alertStatus = .custom
            } else {
                guard let code = code else {
                    return
                }
                self?.code = code
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

    func checkPasswords() -> Bool {
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
    
    private func checkCurrectUsername() -> Bool {
        for i in username {
            if i != " " {
                return true
            }
        }
        return false
    }
}
