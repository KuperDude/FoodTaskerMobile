//
//  MapView.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 09.01.2023.
//

import SwiftUI
import MapKit

struct CartMapView: UIViewRepresentable {
    @Binding var address: String
    @State private var region: MKCoordinateRegion?
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
                }
            }
        }
        
        if let region = region {
            uiView.setRegion(region, animated: true)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(region: $region)
    }
    
    
    class Coordinator: NSObject, CLLocationManagerDelegate {
        @Binding var region: MKCoordinateRegion?
        
        init(region: Binding<MKCoordinateRegion?>) {
            self._region = region
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
    }
}

struct CartMapView_Previews: PreviewProvider {
    static var previews: some View {
        CartMapView(address: .constant(""))
    }
}
