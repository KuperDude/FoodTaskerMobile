//
//  MapView.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 09.01.2023.
//

import SwiftUI
import MapKit
import YandexMapsMobile

struct CartMapView: UIViewRepresentable {
    @Binding var address: String
    @State private var region: MKCoordinateRegion?
    @State private var polygonRender: MKPolygonRenderer?
    var locationManager = CLLocationManager()
    
    func makeUIView(context: Context) -> MKMapView {
        let map = MKMapView()
       
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = context.coordinator
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
            
            map.showsUserLocation = true
        }
        
        map.showsBuildings = true
        
        map.delegate = context.coordinator
        
        map.addOverlays(self.parseGeoJSON())
        
        return map
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        if !address.isEmpty {
            let geocoder = CLGeocoder()
            geocoder.geocodeAddressString(address) { placemarks, error in
                if error != nil {
                    print(error)
                }
                
                if let placemark = placemarks?.first, let coordinates: CLLocationCoordinate2D = placemark.location?.coordinate {
                    let region = MKCoordinateRegion(
                        center: coordinates,
                        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
                    uiView.setRegion(region, animated: true)
                    locationManager.stopUpdatingLocation()
                    
                    //Create a pin
                    for annotation in uiView.annotations {
                        uiView.removeAnnotation(annotation)
                    }
                    
                    let dropPin = MKPointAnnotation()
                    dropPin.coordinate = coordinates
                    uiView.addAnnotation(dropPin)
                    
                    if !uiView.overlays.filter({ overlay in
                        print(overlay)
                        if let polygon = overlay as? MKPolygon {
                            return polygon.isCoordinateInsidePolygon(coordinates)
                        }
                        return false
                    }).isEmpty {
                        print("LETTTTSSSS GOOO")
                    } else {
                        print("NOOOOOOOOO!!!!!!")
                    }
                }
            }
        }
        
        if let region = region {
            uiView.setRegion(region, animated: true)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(region: $region, address: $address)
    }
    
    func parseGeoJSON() -> [MKOverlay] {
        guard let url = Bundle.main.url(forResource: "map", withExtension: "json") else {
            return []
        }
        
        var geoJson = [MKGeoJSONObject]()
        do {
            let data = try Data(contentsOf: url)
            geoJson = try MKGeoJSONDecoder().decode(data)
        } catch {
            fatalError("")
        }
        var overlays = [MKOverlay]()
        
        for item in geoJson {
            if let feature = item as? MKGeoJSONFeature {
                for geo in feature.geometry {
                    if let polygon = geo as? MKPolygon {
                        overlays.append(polygon)
                    }
                }
            }
        }
        return overlays
    }
    
    
    class Coordinator: NSObject, CLLocationManagerDelegate, MKMapViewDelegate {
        @Binding var region: MKCoordinateRegion?
        @Binding var address: String
        
        init(region: Binding<MKCoordinateRegion?>, address: Binding<String>) {
            self._region = region
            self._address = address
        }
        
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            
            if let location = locations.last {
                let center = CLLocationCoordinate2D(
                    latitude: location.coordinate.latitude,
                    longitude: location.coordinate.longitude
                )
                let region = MKCoordinateRegion(
                    center: center,
                    span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                )
                self.region = region
            }
        }
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let polygon = overlay as? MKPolygon {
                let render = MKPolygonRenderer(polygon: polygon)
                render.fillColor = UIColor(red: 1.0, green: 0, blue: 0, alpha: 0.3)
                render.lineWidth = 1
                render.strokeColor = .black
                return render
            }
            
            return MKOverlayRenderer(overlay: overlay)
        }
        
        func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
            mapView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(_:))))
        }
        
        @objc func handleTap(_ gestureRecognizer: UITapGestureRecognizer) {
            let mapView = gestureRecognizer.view as! MKMapView
            let touchPoint = gestureRecognizer.location(in: mapView)
            let coordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
            
            // Use the 'coordinate' to perform your desired actions
            
            let geocoder = CLGeocoder()
            let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)

            geocoder.reverseGeocodeLocation(location) { placemarks, error in
                guard let placemark = placemarks?.first, error == nil else {
                    // Handle error if any
                    return
                }
                
                // Use the placemark to extract the address
                let address = "\(placemark.thoroughfare ?? ""), \(placemark.subThoroughfare ?? "")"
                
                self.address = address
                print(address)                
            }
        }
    }
}

struct CartMapView_Previews: PreviewProvider {
    static var previews: some View {
        CartMapView(address: .constant(""))
    }
}
