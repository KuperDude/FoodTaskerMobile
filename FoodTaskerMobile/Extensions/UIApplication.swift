//
//  UIApplication.swift
//  SwiftfulCrypto
//
//  Created by Nick Sarno on 5/9/21.
//

import Foundation
import SwiftUI

extension UIApplication {
    
    ///dismiss keyboard
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
}

extension UIApplication {
    var firstKeyWindow: UIWindow? {
        let windowScenes = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
        
        let activeScene = windowScenes
            .filter { $0.activationState == .foregroundActive }
        
        let firstActiveScene = activeScene.first
        
        let keyWindow = firstActiveScene?.keyWindow
        
        return keyWindow
    }
}
