//
//  CreditCardAnimationView.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 16.12.2022.
//

import SwiftUI
import Lottie

struct CreditCardAnimationView: UIViewRepresentable {
    let animationView = LottieAnimationView(name: "99865-credit-card")
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        
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

struct CreditCardAnimationView_Previews: PreviewProvider {
    static var previews: some View {
        CreditCardAnimationView()
    }
}
