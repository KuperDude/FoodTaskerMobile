//
//  ForgotPasswordViewModel.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 15.02.2024.
//

import Foundation

class ForgotPasswordViewModel: ObservableObject {
    
    @Published var mail: String = ""
    
    @Published var code: String = ""
    
    @Published var password1: String = ""
    @Published var password2: String = ""
    
    @Published var alertStatus: AlertStatus?
    
    @Published var state: State = .mail
    
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
        case smallPassword   = "Пароль должен содержать не менее 8 символов"
    }
    
    //MARK: - USER INTENT(S)
    func changeState() {
        state = state.changeState()
    }
    func close() {
        mail = ""
        code = ""
        password1 = ""
        password2 = ""
        state = .closed
    }
    
    
    func mailButtonAction() {
        changeState()
    }
    
    func codeButtonAction() {
        changeState()
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
        
        changeState()
    }
    
    func readyButtonAction() {
        changeState()
    }
}
