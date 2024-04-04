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
    
    func placeOrder(on vc: UIViewController, result: @escaping (Result<PaymentStatusResponse, any Error>) -> Void) {
        let paymentData: PaymentInitData = PaymentInitData(amount: 10.0, orderId: "1090", customerKey: "1")
        let configuration = AcquiringViewConfiguration()
        configuration.popupStyle = .bottomSheet
        if let startViewHeight = vc.view.window?.windowScene?.screen.bounds.height {
            configuration.startViewHeight = startViewHeight / 2
        }

        acquiringSDK?.presentPaymentView(on: vc, paymentData: paymentData, configuration: configuration, completionHandler: result)
    }

}
