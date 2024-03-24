//
//  ResetPasswordAnimationView.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 15.02.2024.
//

import SwiftUI
import Lottie

struct ResetPasswordAnimationView: UIViewRepresentable {
    let animationView = LottieAnimationView(name: "1708031048469-open-lock")
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        
        animationView.frame = CGRect(x: 0, y: 0, width: 150, height: 200)
        animationView.contentMode = .scaleAspectFill
        animationView.loopMode = .playOnce
        animationView.animationSpeed = 3
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
    ResetPasswordAnimationView()
}
