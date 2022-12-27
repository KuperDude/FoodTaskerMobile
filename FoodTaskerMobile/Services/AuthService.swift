//
//  AuthService.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 19.12.2022.
//

import Foundation
import vk_ios_sdk

final class AuthService: NSObject, VKSdkDelegate, VKSdkUIDelegate, ObservableObject {
    
    static var instance = AuthService()
    
    @Published var isLoggin: Bool = false
    
    private let appId = "51506708"
    private let vkSdk: VKSdk
    
    var token: String? {
        return VKSdk.accessToken()?.accessToken
    }

    var userID: String? {
        return VKSdk.accessToken()?.userId
    }
    
    override init() {
        
        vkSdk = VKSdk.initialize(withAppId: appId)
        
        super.init()

        vkSdk.register(self)
        vkSdk.uiDelegate = self
    }
    
    func wakeUpSession() {
        let scope = ["wall", "friends"]

        VKSdk.wakeUpSession(scope) { [weak self] (state, error) in

            if state == .authorized {
                print("VKAuthorizationState.authorized")
                self?.isLoggin = true
            } else if state == .initialized {
                print("VKAuthorizationState.initialized")
                VKSdk.authorize(scope)
            } else {
                print("Error with auth")
//                delegate?.authServiceDidSignInFail()
            }
        }
    }
    
    // MARK: - VKSdkDelegate
    func vkSdkAccessAuthorizationFinished(with result: VKAuthorizationResult!) {
        if result.token != nil {
            isLoggin = true
        }
    }

    func vkSdkUserAuthorizationFailed() {
    
    }
    
    
    // MARK: - VKSDKUiDelegate
    func vkSdkShouldPresent(_ controller: UIViewController!) {
//        delegate?.authServiceShouldShow(controller)
    }

    func vkSdkNeedCaptchaEnter(_ captchaError: VKError!) {

    }
    
}
