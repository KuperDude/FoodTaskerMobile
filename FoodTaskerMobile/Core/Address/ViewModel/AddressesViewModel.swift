//
//  AddressesViewModel.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 27.11.2023.
//

import Foundation
import Combine
import SwiftUI
import CoreLocation
import YandexMapsMobile

class AddressesViewModel: ObservableObject {
    
    @ObservedObject var mainVM: MainViewModel
    
    private let geoJSONService = GeoJSONService.instance
    
    private var cancellables = Set<AnyCancellable>()
    
    init(mainVM: MainViewModel) {
        self._mainVM = ObservedObject(initialValue: mainVM)
    }
    
    func getDeliveryPriceOf(address: Address, price: @escaping (Int?) -> Void) {
        convertToPoint(address: address) { [weak self] point in
            guard 
                let point = point,
                let self = self
            else { return }
            for obj in self.geoJSONService.polygons {
                if obj.polygon.isCoordinateInsidePolygon(CLLocationCoordinate2D(latitude: point.latitude, longitude: point.longitude)) {                    
                    price(obj.price)
                    return
                }
            }
            price(nil)
        }
    }
    
    private func convertToPoint(address: Address, complition: @escaping (YMKPoint?) -> Void) {
        let strAddress = address.city + ", " + address.convertToString()
        if !strAddress.isEmpty {
            let geocoder = CLGeocoder()
            geocoder.geocodeAddressString(strAddress) { placemarks, error in
                
                if let placemark = placemarks?.first, let coordinates: CLLocationCoordinate2D = placemark.location?.coordinate {
                    complition(YMKPoint(latitude: coordinates.latitude, longitude: coordinates.longitude))
                }
            }
        } else {
            complition(nil)
        }
    }
}
