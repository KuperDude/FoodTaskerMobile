//
//  DeliveryMapView.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 27.01.2023.
//

import SwiftUI
import MapKit

struct DeliveryMapView: UIViewRepresentable {
    var restaurantAddress: MKPlacemark?
    var customerAddress: MKPlacemark?
    
    @StateObject var vm = DeliveryMapViewModel()
    
    var map = MKMapView()

    init() {
        getData()
    }
    
    func makeUIView(context: Context) -> MKMapView {
        map.delegate = context.coordinator
        return map
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator()
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = UIColor.black
            renderer.lineWidth = 5
            return renderer
        }

    }
    
}

struct DeliveryMapView_Previews: PreviewProvider {
    static var previews: some View {
        CartMapView(address: .constant(""))
    }
}

// MARK: - Functions
extension DeliveryMapView {
    func getData() {
        if vm.addresses.count == 2 {
            self.getLocation(vm.addresses[0], "Restaurant") { res in
                self.getLocation(vm.addresses[1], "Customer") { cus in
                    self.getDirection(res, cus)
                }
            }
        }
    }
    
    // Convert an address (string) to a location on the map
    func getLocation(_ address: String, _ title: String, completionHandler: @escaping (MKPlacemark) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { place, error in
            
        }
        geocoder.geocodeAddressString(address) { placemarks, error in
            if error != nil {
                print(error as Any)
            }
            
            guard
                let placemark = placemarks?.first,
                let coordinates: CLLocationCoordinate2D = placemark.location?.coordinate
            else { return }
            
            let dropPin = MKPointAnnotation()
            dropPin.coordinate = coordinates
            dropPin.title = title
            self.map.addAnnotation(dropPin)
            
            completionHandler(MKPlacemark(placemark: placemark))
            
        }
    }

    //get direction and zoom to location on the map
    func getDirection(_ restaurantAddress: MKPlacemark?, _ customerAddress: MKPlacemark?) {
        let request = MKDirections.Request()
        guard let restaurantAddress = restaurantAddress, let customerAddress = customerAddress else { return }
        request.source = MKMapItem(placemark: restaurantAddress)
        request.destination = MKMapItem(placemark: customerAddress)
        request.requestsAlternateRoutes = false
        
        let directions = MKDirections(request: request)
        directions.calculate { response, error in
            if error != nil {
                print(error as Any)
            } else {
                
            }
        }
    }
    
    // Show route between locations and make a visible zoom
    func showRoute(response: MKDirections.Response) {
        for route in response.routes {
            self.map.addOverlay(route.polyline, level: MKOverlayLevel.aboveRoads)
        }
        
        map.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        map.showAnnotations(map.annotations, animated: true)
    }
}
