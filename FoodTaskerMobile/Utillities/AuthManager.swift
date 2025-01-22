//
//  AuthManager.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 19.12.2022.
//

import Foundation
import vk_ios_sdk
import Combine
import GoogleSignIn

final class AuthManager: NSObject, ObservableObject {
    
    static var instance = AuthManager()
    
    @Published var user: User?
    
    private let vkSdk: VKSdk
    
    func token(method: RegistrationMethod) -> String? {
        return method == .vk ? VKSdk.accessToken()?.accessToken : GIDSignIn.sharedInstance.currentUser?.accessToken.tokenString
    }

    var userID: String? {
        return VKSdk.accessToken()?.userId
    }
    
    enum RegistrationMethod {
        case vk
        case google
    }
    
    override init() {
        
        vkSdk = VKSdk.initialize(withAppId: Constants.VK_APP_ID)
        
        super.init()

        vkSdk.register(self)
    }
    
    private func getUserFromData() async throws {
        let data = try await getUserData()
        let response = try JSONDecoder().decode(ResponseUser.self, from: data)
        
        await MainActor.run {
            self.user = response.users.first?.convertToUser()
        }
    }
    
    func register(username: String, mail: String, password: String, completion: @escaping (_ error: String?) -> Void) {
        APIManager.instance.register(username: username, mail: mail, password: password) { [weak self] result in
            switch result {
            case .success(let bool): 
                if bool {
                    self?.login(mail: mail, password: password, completion: completion)
                }
            case .failure(_): break
            }
        }
    }
    
    func deleteAccount(completion: @escaping (_ error: String?) -> Void) {
        APIManager.instance.deleteAccount { [weak self] result in
            switch result {
            case .success(let bool):
                if bool {
                    VKSdk.forceLogout()
                    GIDSignIn.sharedInstance.signOut()
                    AuthManager.instance.user = nil
                    APIManager.instance.logout(.vk) { _ in }
                    APIManager.instance.logout(.google) { _ in }
                    self?.user = nil
                    completion(nil)
                }
            case .failure(let error): completion(error.localizedDescription)
            }
        }
    }
    
    func login(mail: String, password: String, completion: @escaping (_ error: String?) -> Void) {
        APIManager.instance.login(mail: mail, password: password) { [weak self] result in
            switch result {
            case .success(let resUser): 
                self?.user = resUser.convertToUser()
                completion(nil)
            case .failure(let error): completion((error as? StringError)?.description)
            }
        }
    }
}

// MARK: - VKSdkDelegate
extension AuthManager: VKSdkDelegate {
    func vkSdkAccessAuthorizationFinished(with result: VKAuthorizationResult!) {
        if result.token != nil && !result.token.isExpired() {
            Task {
                try await APIManager.instance.login(method: .vk, userType: Constants.USERTYPE_CUSTOMER)
                try await self.getUserFromData()
            }
        }
    }

    func vkSdkUserAuthorizationFailed() {}
}

// MARK: - ResetPasswordAllow, SendCodeAllow
extension AuthManager: ResetPasswordAllow, SendCodeAllow {
    
    func resetPassword(mail: String, password: String) async throws -> Bool {
        return try await withCheckedThrowingContinuation { continuation in
            APIManager.instance.resetPassword(mail: mail, password: password) { result in
                switch result {
                case .success(let bool): continuation.resume(returning: bool)
                case .failure(let error): continuation.resume(throwing: error)
                }
            }
        }
    }
    
    func sendCodeOn(mail: String) async throws -> Int {
        return try await withCheckedThrowingContinuation { continuation in
            APIManager.instance.sendCode(mail: mail) { result in
                switch result {
                case .success(let code):                     
                    continuation.resume(returning: code)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    func sendResetCodeOn(mail: String) async throws -> Int {
        return try await withCheckedThrowingContinuation { continuation in
            APIManager.instance.sendCode(mail: mail, isResetPassword: true) { result in
                switch result {
                case .success(let code): continuation.resume(returning: code)
                case .failure(let error): continuation.resume(throwing: error)
                }
            }
        }
    }
}

// MARK: - Social Auth
extension AuthManager {
    func handleAuthorization(method: RegistrationMethod) async throws -> Bool {
        switch method {
        case .vk:
            if try await APIManager.instance.login(method: .vk, userType: Constants.USERTYPE_CUSTOMER) {
                try await getUserFromData()
                return true
            }
            return false
        case .google:
            return try await APIManager.instance.login(method: .google, userType: Constants.USERTYPE_CUSTOMER)
        }
    }
    
    func wakeUpSession(method: RegistrationMethod, isAlreadyLogin: Bool = false) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            switch method {
            case .vk:
                let scope = ["wall", "photos", "email"]

                VKSdk.wakeUpSession(scope) { (state, error) in
                    
                    guard error == nil else {
                        continuation.resume(throwing: error!)
                        return
                    }
                    
                    switch state {
                    case .initialized:
                        if !isAlreadyLogin {
                            VKSdk.authorize(scope)
                        }
                        continuation.resume(returning: Void())
                    case .authorized:
                        continuation.resume(returning: Void())
                    default:
                        continuation.resume(throwing: URLError(.badURL))
                    }
                }

            case .google:
                GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
                    
                    if (error != nil || user == nil) && !isAlreadyLogin {
                        
                        GIDSignIn.sharedInstance.signIn(withPresenting: (UIApplication.shared.firstKeyWindow?.rootViewController)!) { result, error in
                            guard error == nil else { return }
                            guard let result = result else { return }
                            
                            let user = result.user
                            guard
                                let id = user.userID,
                                let profile = user.profile,
                                let imageURL = profile.imageURL(withDimension: 50)?.absoluteString
                            else {
                                return
                            }
                            
                            DispatchQueue.main.async {
                                self.user = User(id: id, firstName: profile.name, lastName: "", imageURL: imageURL)
                            }
                        }
                        continuation.resume(returning: Void())
                        return
                    }
                    
                    if error == nil && user != nil {
                        guard
                            let id = user?.userID,
                            let profile = user?.profile,
                            let imageURL = profile.imageURL(withDimension: 50)?.absoluteString
                        else {
                            return
                        }
                        
                        DispatchQueue.main.async {
                            self.user = User(id: id, firstName: profile.name, lastName: "", imageURL: imageURL)
                        }
                        continuation.resume(returning: Void())
                    } else if let error = error {
                        continuation.resume(throwing: error)
                    } else {
                        continuation.resume(throwing: URLError(.badURL))
                    }
                }
            }
        }
    }
    
    private func getUserData() async throws -> Data {
        return try await withCheckedThrowingContinuation { continuation in
            let request: VKRequest = VKRequest(method: "users.get", andParameters: ["fields": ["photo_50", "contacts", "email"]], andHttpMethod: "GET")
            request.execute { response in
                let string = response?.responseString
                if let data = string?.data(using: .utf8) {
                    return continuation.resume(returning: data)
                }
            } errorBlock: { error in
                if let error = error {
                    return continuation.resume(throwing: error)
                }
            }
        }
    }
}
