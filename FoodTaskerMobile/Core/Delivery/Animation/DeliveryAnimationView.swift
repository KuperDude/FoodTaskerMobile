//
//  DeliveryAnimationView.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 10.03.2024.
//

import SwiftUI
import Lottie

struct DeliveryAnimationView: UIViewRepresentable {
    let animationView = LottieAnimationView(name: "1710081107528-delivery-driver")
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        
        animationView.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.animationSpeed = 0.5
        animationView.play()
        
        view.addSubview(animationView)
        
        NSLayoutConstraint.activate([
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor),
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor),
        ])
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
}

#Preview {
    DeliveryAnimationView()
}
