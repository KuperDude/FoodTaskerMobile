//
//  MapTrackingAnimationView.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 15.03.2024.
//

import SwiftUI
import Lottie

struct MapTrackingAnimationView: UIViewRepresentable {
    @Binding var isScrolling: MapViewModel.BundleStatus
    let animationView = LottieAnimationView(name: "1710451613546-map-tracking")
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        
        animationView.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        animationView.contentMode = .scaleAspectFit
        animationView.currentProgress = AnimationProgressTime(0.5)
        
        view.addSubview(animationView)
        
        NSLayoutConstraint.activate([
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor),
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor),
        ])
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        
        for view in uiView.subviews {
            view.removeFromSuperview()
        }
        animationView.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        animationView.contentMode = .scaleAspectFit
        animationView.currentProgress = AnimationProgressTime(isScrolling == .scrolled || isScrolling == .limitOut ? 1.0 : 0.5)
        
        uiView.addSubview(animationView)
        
        NSLayoutConstraint.activate([
            animationView.heightAnchor.constraint(equalTo: uiView.heightAnchor),
            animationView.widthAnchor.constraint(equalTo: uiView.widthAnchor),
        ])
    }
}

#Preview {
    MapTrackingAnimationView(isScrolling: .constant(.scrolled))
}
