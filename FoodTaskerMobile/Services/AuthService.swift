//
//  AuthService.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 19.12.2022.
//

import Foundation
import vk_ios_sdk
import Combine

final class AuthService: NSObject, VKSdkDelegate, ObservableObject {
    
    static var instance = AuthService()
    
    private var userSubscription: AnyCancellable?
    
    @Published var user: User?
    
    private let vkSdk: VKSdk
    
    var token: String? {
        return VKSdk.accessToken()?.accessToken
    }

    var userID: String? {
        return VKSdk.accessToken()?.userId
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
    
    func wakeUpSession() {
        //photos
        let scope = ["wall", "photos"]

        VKSdk.wakeUpSession(scope) { [weak self] (state, error) in

            if state == .authorized {
                print("VKAuthorizationState.authorized")
                APIManager.instance.login(userType: USERTYPE_CUSTOMER) { error in
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
    }
    
    private func getUserData(_ completion: @escaping (Result<Data, Error>) -> Void) {
        let request: VKRequest = VKRequest(method: "users.get", andParameters: ["fields": ["photo_50"]], andHttpMethod: "GET")
        request.execute { response in
            let string = response?.responseString
            if let data = string?.data(using: .utf8) {
                UserDefaults.standard.set(data, forKey: "user")
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
            APIManager.instance.login(userType: USERTYPE_CUSTOMER) { error in
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
