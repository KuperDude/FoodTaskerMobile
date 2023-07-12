//
//  MapView.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 12.05.2023.
//

import MapKit
import SwiftUI

struct MapView: UIViewRepresentable {
    
    @State var deliveryArea: MKCoordinateRegion?
    @State var map: MKMapView?
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView(frame: .zero)
        mapView.delegate = context.coordinator // регистрируем делегата карты

        // настраиваем карту
        let initialLocation = CLLocation(latitude: 37.786996, longitude: -122.440100)
        let regionRadius: CLLocationDistance = 1000
        let coordinateRegion = MKCoordinateRegion(center: initialLocation.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        deliveryArea = coordinateRegion
        mapView.setRegion(coordinateRegion, animated: true)
        map = mapView
        return mapView
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        let deliveryArea = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.786996, longitude: -122.440100), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        let polygon = MKPolygon(coordinates: [
            CLLocationCoordinate2D(latitude: 37.781893,longitude: -122.411155),
            CLLocationCoordinate2D(latitude: 37.789950,longitude:-122.411155),
            CLLocationCoordinate2D(latitude: 37.789950,longitude:-122.392532),
            CLLocationCoordinate2D(latitude: 37.781893,longitude:-122.392532)
        ], count: 4)

        uiView.addOverlay(polygon)

        let tapRecognizer = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.mapTapped(_:)))
        uiView.addGestureRecognizer(tapRecognizer)

    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView

        init(_ parent: MapView) {
            self.parent = parent
        }

        @objc func mapTapped(_ gestureRecognizer: UITapGestureRecognizer) {
            
            guard
                let map = parent.map,
                let deliveryArea = parent.deliveryArea
            else { return }
            
            let location = gestureRecognizer.location(in: map)
            let coordinate = map.convert(location, toCoordinateFrom: map)

            showAddresses(for: coordinate)
            
            let mapRect = MKMapRect(origin: MKMapPoint(deliveryArea.center), size: MKMapSize(width: deliveryArea.span.latitudeDelta, height: deliveryArea.span.longitudeDelta))

            if !mapRect.contains(MKMapPoint(coordinate)) {
                // Если выбранный адрес не находится в границе доставки, выведите предупреждение
                print("Выбранный адрес находится за пределами границы доставки")
            }
        }
        
        func showAddresses(for coordinate: CLLocationCoordinate2D) {
            let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
            CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
                if let error = error {
                    print("Ошибка при поиске адреса: \(error.localizedDescription)")
                    return
                }

                guard let placemark = placemarks?.first else {
                    print("Адрес не найден")
                    return
                }

                print("Адрес: \(placemark.description)")
            }
        }
    }


}

