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
                self?.user = response.users.first
            }
    }
    
    func login(mail: String) {
        APIManager.instance.login(mail: mail) { result in
            switch result {
            case .success(let code): print("---\(code)---")
            case .failure(_): break
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
                                
                                self?.user = User(id: 123, firstName: profile.name, lastName: "", imageURL: imageURL)
                                
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
                            self?.user = User(id: 123, firstName: profile.name, lastName: "", imageURL: imageURL)
                            
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
