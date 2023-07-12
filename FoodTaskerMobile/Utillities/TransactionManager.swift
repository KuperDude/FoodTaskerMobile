//
//  TransactionManager.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 09.01.2023.
//

import Foundation
import SwiftyJSON
import TinkoffASDKCore
import TinkoffASDKUI
import UIKit

class TransactionManager {
    static let instance = TransactionManager()

    let sdk: AcquiringSdkConfiguration
    let acquiringSDK: AcquiringUISDK?

    init() {
        let credential = AcquiringSdkCredential(terminalKey: TERMINAL_KEY, publicKey: PUBLIC_KEY)
        sdk = AcquiringSdkConfiguration(
            credential: credential,
            server: .test,
            requestsTimeoutInterval: 40,
            tinkoffPayStatusCacheLifeTime: 300,
            tokenProvider: nil,
            urlSessionAuthChallengeService: nil
        )
        
        acquiringSDK = try? AcquiringUISDK(configuration: sdk)
    }
    
    func placeOrder(on vc: UIViewController) {
        let paymentData: PaymentInitData = PaymentInitData(amount: 10.0, orderId: "1090", customerKey: "1")
        //print(acquiringSDK)

//        acquiringSDK?.presentCardList(on: vc, customerKey: "1", configuration: AcquiringViewConfiguration())
        acquiringSDK?.presentPaymentView(on: vc, paymentData: paymentData, configuration: AcquiringViewConfiguration(), completionHandler: { result in
            
        })
    }
}
