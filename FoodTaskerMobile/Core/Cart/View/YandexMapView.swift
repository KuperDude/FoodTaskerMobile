//
//  YandexMapView.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 15.07.2023.
//

import Foundation
import SwiftUI
import YandexMapsMobile
import MapKit
import CoreLocation

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
        
//        let scale = UIScreen.main.scale
//        let mapKit = YMKMapKit.sharedInstance()
//        let userLocationLayer = mapKit.createUserLocationLayer(with: mapView.mapWindow)
//        userLocationLayer.setVisibleWithOn(true)
//        userLocationLayer.isHeadingEnabled = true
//        userLocationLayer.setObjectListenerWith(context.coordinator)
//
//        userLocationLayer.setAnchorWithAnchorNormal(
//            CGPoint(x: 0.5 * mapView.frame.size.width * scale, y: 0.5 * mapView.frame.size.height * scale),
//            anchorCourse: CGPoint(x: 0.5 * mapView.frame.size.width * scale, y: 0.83 * mapView.frame.size.height * scale))
        

//        let polygon = mapView.mapWindow.map.mapObjects.addPolygon(
//            with: YMKPolygon(outerRing: YMKLinearRing(points: parseGeoJSON()), innerRings: []))
//        polygon.fillColor = UIColor(red: 1.0, green: 0, blue: 0, alpha: 0.3)
//        polygon.strokeColor = UIColor.black
//        polygon.strokeWidth = 1
//        polygon.zIndex = 100
        
        return mapView
    }
         
    func updateUIView(_ mapView: YMKMapView, context: Context) {
//        mapVM.convertAddress()
    }
    
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
