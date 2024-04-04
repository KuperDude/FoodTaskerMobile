//
//  YandexMapView.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 15.07.2023.
//

import SwiftUI
import YandexMapsMobile


struct YandexMapView: UIViewRepresentable {
    @ObservedObject var mapVM: MapViewModel
    
    init(mapVM: MapViewModel) {
        self._mapVM = ObservedObject(initialValue: mapVM)
    }
    
    func makeUIView(context: Context) -> YMKMapView {
        let mapView = mapVM.mapView
        mapView.mapWindow.map.isRotateGesturesEnabled = false
        mapView.mapWindow.map.move(with:
            YMKCameraPosition(target: YMKPoint(latitude: 0, longitude: 0), zoom: 12, azimuth: 0, tilt: 0))
        
        return mapView
    }
         
    func updateUIView(_ mapView: YMKMapView, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(mapView: $mapVM.mapView)
    }
    
    class Coordinator: NSObject, YMKUserLocationObjectListener {
        @Binding var mapView: YMKMapView
        
        init(mapView: Binding<YMKMapView>) {
            self._mapView = mapView
        }
        
        //YMKUserLocationObjectListener
        func onObjectAdded(with view: YMKUserLocationView) {
            view.arrow.setIconWith(UIImage(systemName: "person.circle")!)
            let pinPlacemark = view.pin.useCompositeIcon()
            
            pinPlacemark.setIconWithName("person.circle",
                                         image: UIImage(systemName: "person.circle")!,
                style:YMKIconStyle(
                    anchor: CGPoint(x: 0, y: 0) as NSValue,
                    rotationType:YMKRotationType.rotate.rawValue as NSNumber,
                    zIndex: 0,
                    flat: true,
                    visible: true,
                    scale: 1.5,
                    tappableArea: nil))
            
            pinPlacemark.setIconWithName(
                "person.circle",
                image: UIImage(systemName: "person.circle")!,
                style:YMKIconStyle(
                    anchor: CGPoint(x: 0.5, y: 0.5) as NSValue,
                    rotationType:YMKRotationType.rotate.rawValue as NSNumber,
                    zIndex: 1,
                    flat: true,
                    visible: true,
                    scale: 1,
                    tappableArea: nil))

            view.accuracyCircle.fillColor = UIColor.blue
        }
        
        func onObjectRemoved(with view: YMKUserLocationView) {}
        
        func onObjectUpdated(with view: YMKUserLocationView, event: YMKObjectEvent) {}
    
    }
    
}
