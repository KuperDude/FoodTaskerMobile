//
//  ForgotPasswordViewModel.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 15.02.2024.
//

import Foundation

class ForgotPasswordViewModel: ObservableObject {
    var authService: AuthService
    
    @Published var mail: String = ""
    
    @Published var code: Int?
    @Published var internalCode: String = ""
    
    @Published var password1: String = ""
    @Published var password2: String = ""
    
    @Published var alertStatus: AlertStatus?
    @Published var customErrorDescription: String?
    
    @Published var state: State = .mail
    
    init() {
        self.authService = AuthService.instance
    }
    
    enum State: Int {
        case closed = 0
        case mail
        case code
        case reset
        case ready
        
        func changeState() -> State {
            switch self {
            case .closed: return .mail
            case .mail: return .code
            case .code: return .reset
            case .reset: return .ready
            case .ready: return .closed
            }
        }
    }
    
    enum AlertStatus: String {
        case noEqualPassword = "Пароли не совпадают!"
        case smallPassword   = "Пароль должен содержать не менее 8 символов!"
        case noEqualCode     = "Код не совпадает!"
        case noExistCode     = "Проблемы с приходом кода!"
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
    
    //MARK: - USER INTENT(S)
    func changeState() {
        state = state.changeState()
    }
    func close() {
        mail = ""
        code = nil
        internalCode = ""
        password1 = ""
        password2 = ""
        state = .closed
    }
    
    
    func sendCode() {
        authService.resetPasswordSendCode(mail: mail) { [weak self] code, error in
            if error != nil {
                self?.customErrorDescription = error
                self?.alertStatus = .custom
                return
            } else {
                guard let code = code else {
                    return
                }
                self?.code = code
            }
            self?.changeState()
        }
    }
    
    func codeButtonAction() {
        
        guard
            let code = code,
            let internalCode = Int(internalCode)
        else {
            alertStatus = .noExistCode
            return
        }
        
        if code == internalCode {
            self.internalCode = ""
            self.code = nil
            self.changeState()
        } else {
            alertStatus = .noEqualCode
        }
    }
    
    func resetButtonAction() {
        if password1.count < 8 || password2.count < 8 {
            alertStatus = .smallPassword
            return
        }
        if password1 != password2 {
            alertStatus = .noEqualPassword
            return
        }
        authService.resetPassword(mail: mail, password: password1) { [weak self] bool, error in
            if bool {
                self?.changeState()
            }
        }
    }
    
    func readyButtonAction() {
        changeState()
    }
}
