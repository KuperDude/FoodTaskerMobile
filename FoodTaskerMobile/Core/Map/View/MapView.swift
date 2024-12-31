//
//  MapView.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 12.05.2023.
//

import MapKit
import SwiftUI
import YandexMapsMobile

struct MapView: View {
    @ObservedObject var mapVM: MapViewModel
    
    init(mapVM: MapViewModel) {
        self.mapVM = mapVM
    }
    var body: some View {
        ZStack {
            YandexMapView(mapVM: mapVM)
            
            pinAndBundle
        }
    }
}

extension MapView {
    var pinAndBundle: some View {
        ZStack {
            //bundle
            if mapVM.bundleStatus == .forbidden || mapVM.bundleStatus == .unknown || mapVM.bundleStatus == .limitOut {
                Text(mapVM.bundleStatus.rawValue)
                    .fontWeight(.semibold)
                    .padding(5)
                    .background {
                        RoundedRectangle(cornerRadius: 5)
                            .foregroundColor(.orange)
                    }
                    .offset(y: mapVM.bundleStatus == .limitOut ? -150 : -75)
            }
            //pin
            ZStack {
                MapTrackingAnimationView(isScrolling: $mapVM.bundleStatus)
                    .frame(width: 200, height: 200)
                    .allowsHitTesting(false)
                    .padding(.bottom, 50)
                if mapVM.bundleStatus == .limitOut {
                    ProgressView()
                        .frame(width: 5, height: 5)
                } else {
                    Circle()
                        .frame(width: 5, height: 5)
                        .foregroundStyle(.red)
                        .opacity(mapVM.bundleStatus == .scrolled ? 1.0 : 0.0)
                }
            }
        }
        .ignoresSafeArea(.keyboard)
    }
}
