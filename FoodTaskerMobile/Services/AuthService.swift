//
//  AuthService.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 19.12.2022.
//

import Foundation
import vk_ios_sdk
import Combine
import GoogleSignIn

final class AuthService: NSObject, VKSdkDelegate, ObservableObject {
    
    static var instance = AuthService()
    
    private var userSubscription: AnyCancellable?
    
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
        
        vkSdk = VKSdk.initialize(withAppId: VK_APP_ID)
        
        super.init()

        vkSdk.register(self)
    }
    
    private func addSubscriber() {
        userSubscription = getUserData()
            .receive(on: DispatchQueue.main)
            .decode(type: ResponseUser.self, decoder: JSONDecoder())
            .sink { result in
                switch result {
                case .failure(let error):
                    print(error)
                default: break
                }
            } receiveValue: { [weak self] response in
                self?.user = response.users.first?.convertToUser()
            }
    }
    
    func sendCode(mail: String, completion: @escaping (_ code: Int?, _ error: String?) -> Void) {
        APIManager.instance.sendCode(mail: mail) { result in
            switch result {
            case .success(let code): completion(code, nil)
            case .failure(let error): completion(nil, (error as? StringError)?.description)
            }
        }
    }
    
    func resetPasswordSendCode(mail: String, completion: @escaping (_ code: Int?, _ error: String?) -> Void) {
        APIManager.instance.sendCode(mail: mail, isResetPassword: true) { result in
            switch result {
            case .success(let code): completion(code, nil)
            case .failure(let error): completion(nil, (error as? StringError)?.description)
            }
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
    
    func resetPassword(mail: String, password: String, completion: @escaping (Bool, _ error: String?) -> Void) {
        APIManager.instance.resetPassword(mail: mail, password: password) { result in
            switch result {
            case .success(let bool): completion(bool, nil)
            case .failure(let error): completion(false, (error as? StringError)?.description)
            }
        }
    }
    
    func alreadyLoginSession(method: RegistrationMethod) {
        switch method {
        case .vk:
            let scope = ["wall", "photos"]
            
            VKSdk.wakeUpSession(scope) { (state, error) in
                if state == .authorized {
                    print("VKAuthorizationState.authorized")
                    APIManager.instance.login(method: .vk, userType: USERTYPE_CUSTOMER) { [weak self] error in
                        if error == nil {
                            self?.addSubscriber()
                        } else {
                            print(error)
                        }
                    }
                } else {
                    print("Error with auth")
                    //                delegate?.authServiceDidSignInFail()
                }
            }
            
        case.google:
            GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
                if error == nil && user != nil {
                    print("GoogleAuthorizationState.authorized")
                    APIManager.instance.login(method: .google, userType: USERTYPE_CUSTOMER) { [weak self] error in
                        guard
                            let id = user?.userID,
                            let profile = user?.profile,
                            let imageURL = profile.imageURL(withDimension: 50)?.absoluteString
                        else {
                            return
                        }
                        
                        self?.user = User(id: id, firstName: profile.name, lastName: "", imageURL: imageURL)
                    }
                }
            }
        }
    }
    
    func wakeUpSession(method: RegistrationMethod) {
        
        switch method {
        case .vk:
            //photos
            let scope = ["wall", "photos"]

            VKSdk.wakeUpSession(scope) { [weak self] (state, error) in

                if state == .authorized {
                    print("VKAuthorizationState.authorized")
                    APIManager.instance.login(method: .vk, userType: USERTYPE_CUSTOMER) { [weak self] error in
                        if error == nil {
                            self?.addSubscriber()
                        } else {
                            print(error)
                        }
                    }
                } else if state == .initialized {
                    print("VKAuthorizationState.initialized")
                    VKSdk.authorize(scope)
                } else {
                    print("Error with auth")
    //                delegate?.authServiceDidSignInFail()
                }
            }
        case .google:
            GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
                if error != nil || user == nil {
                    print("GoogleAuthorizationState.initialized")
                    GIDSignIn.sharedInstance.signIn(withPresenting: (UIApplication.shared.firstKeyWindow?.rootViewController)!) { result, error in
                        guard error == nil else { return }
                        guard let result = result else { return }

                        let user = result.user
          
                        APIManager.instance.login(method: .google, userType: USERTYPE_CUSTOMER) { [weak self] error in
                            if error == nil {
                                guard
                                    let id = user.userID,
                                    let profile = user.profile,
                                    let imageURL = profile.imageURL(withDimension: 50)?.absoluteString
                                else {
                                    return
                                }
                                
                                self?.user = User(id: id, firstName: profile.name, lastName: "", imageURL: imageURL)
                                
                            } else {
                                print(error)
                            }
                        }
                    }
                } else {
                    print("GoogleAuthorizationState.authorized")
                    APIManager.instance.login(method: .google, userType: USERTYPE_CUSTOMER) { [weak self] error in
                        if error == nil {
                            guard
                                let id = user?.userID,
                                let profile = user?.profile,
                                let imageURL = profile.imageURL(withDimension: 50)?.absoluteString
                            else {                                     
                                return
                            }
                            
                            self?.user = User(id: id, firstName: profile.name, lastName: "", imageURL: imageURL)
                            
                        } else {
                            print(error)
                        }
                    }
                }
            }
        }
    }
    
    private func getUserData(_ completion: @escaping (Result<Data, Error>) -> Void) {
        let request: VKRequest = VKRequest(method: "users.get", andParameters: ["fields": ["photo_50"]], andHttpMethod: "GET")
        request.execute { response in
            let string = response?.responseString
            if let data = string?.data(using: .utf8) {
                return completion(.success(data))
            }
        } errorBlock: { error in
            if let error = error {                
                return completion(.failure(error))
            }
        }
    }
    
    private func getUserData() -> Future<Data, Error> {
        return Future() { promise in
            self.getUserData { result in promise(result) }
        }
    }
    
    
    
    // MARK: - VKSdkDelegate
    func vkSdkAccessAuthorizationFinished(with result: VKAuthorizationResult!) {
        if result.token != nil && !result.token.isExpired() {
            APIManager.instance.login(method: .vk, userType: USERTYPE_CUSTOMER) { error in
                if error == nil {
                    self.addSubscriber()
                } else {
                    print(error)
                }
            }
        }
    }

    func vkSdkUserAuthorizationFailed() {
        
    }
    
}
