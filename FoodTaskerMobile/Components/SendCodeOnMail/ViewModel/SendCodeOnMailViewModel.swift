//
//  SendCodeOnMailViewModel.swift
//  LMS_Mobile
//
//  Created by MyBook on 02.07.2024.
//

import Foundation

protocol SendCodeAllow {
    func sendCodeOn(mail: String) async throws -> Int
}

class SendCodeOnMailViewModel: ObservableObject {
    var authService: SendCodeAllow
    
    var mail: String
    
    @Published var code: Int?
    @Published var internalCode: String = ""
    
    @Published var alertStatus: AlertStatus?
    @Published var customErrorDescription: String?
    
    var completion: ()->Void
        
    init(mail: String, completion: @escaping ()->Void) {
        self.authService = AuthManager.instance
        self.mail = mail
        self.completion = completion
    }
    
    enum AlertStatus: String {
        case noEqualCode     = "Код не совпадает!"
        case noExistCode     = "Проблемы с приходом кода!"
        case invalidedCode   = "Проверьте правильность ввода кода!"
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
    func close() {
        code = nil
        internalCode = ""
    }
    
    
    func sendCode() async {
        do {
            code = try await authService.sendCodeOn(mail: mail)
        } catch {
            customErrorDescription = error.localizedDescription
            alertStatus = .custom
        }
    }
    
    func codeButtonAction() {
        
        guard let code = code else {
            alertStatus = .noExistCode
            return
        }
        
        guard let internalCode = Int(internalCode) else {
            alertStatus = .invalidedCode
            return
        }
        
        if code == internalCode {
            close()
            completion()
        } else {
            alertStatus = .noEqualCode
        }
    }
}
