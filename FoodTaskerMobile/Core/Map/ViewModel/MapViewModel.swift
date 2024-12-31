//
//  MapManager.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 15.07.2023.
//

import Foundation
import CoreLocation
import YandexMapsMobile
import MapKit
import SwiftUI

class MapViewModel: NSObject, ObservableObject {
    @Published var address: Address
    @Published var deliveryPrice: Int?
    @Published var bundleStatus: BundleStatus = .scrolled
    
    private var isStartTimer = false
    private var isZoomChange = false
    
    private var userLocation: CLLocationCoordinate2D?
    private let manager = CLLocationManager()
    private let geoJSONService = GeoJSONService.instance
    
    var mapView: YMKMapView
    
    init(address: Address) {
        
        self.address = address
        self.mapView = geoJSONService.mapView
        super.init()
        convertAddress()
        
        self.manager.delegate = self
        
        addTapListener()
        mapView.mapWindow.map.isNightModeEnabled = true
        mapView.mapWindow.map.mapType = .vectorMap
        mapView.mapWindow.map.poiLimit = 0
        mapView.mapWindow.map.addCameraListener(with: self)
    }
    
    enum BundleStatus: String {
        case forbidden = "Доставка по данному адресу\n       временно недоступна"
        case allowed   = ""
        case unknown   = "Уточните адрес"
        case scrolled  = "\0"
        case limitOut  = "Лимит запросов превышен!\n      Подождите немного"
    }
    
    func addTapListener() {
        mapView.mapWindow.map.addTapListener(with: self)
    }
    
    func convertAddress() {
        let strAddress = address.city + ", " + address.convertToString()
        if !strAddress.isEmpty {
            let geocoder = CLGeocoder()
            geocoder.geocodeAddressString(strAddress) { [weak self] placemarks, error in
                if let placemark = placemarks?.first, let coordinates: CLLocationCoordinate2D = placemark.location?.coordinate {
                    self?.mapView.mapWindow.map.move(with:
                        YMKCameraPosition(target: YMKPoint(latitude: coordinates.latitude, longitude: coordinates.longitude), zoom: 17, azimuth: 0, tilt: 0))
                }
            }
        }
    }
}

extension MapViewModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let coordinate = locations.last?.coordinate else { return }
        userLocation = coordinate
        if mapView.mapWindow.map.cameraPosition.target.longitude == 0 && mapView.mapWindow.map.cameraPosition.target.latitude == 0 {
            mapView.mapWindow.map.move(with:
                YMKCameraPosition(target: YMKPoint(latitude: coordinate.latitude, longitude: coordinate.longitude), zoom: 17, azimuth: 0, tilt: 0))
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        manager.requestAlwaysAuthorization()
        manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        manager.startUpdatingLocation()
    }
}

extension MapViewModel: YMKLayersGeoObjectTapListener {
    
    private func convertCoordinateToAdress(_ coordinate: YMKPoint, complition: @escaping (Address?)->Void) {
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)

        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            self?.bundleStatus = .limitOut
            guard let placemark = placemarks?.first, error == nil else {
                if !(self?.isStartTimer ?? false) {
                    self?.isStartTimer = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 60) { [weak self] in
                        guard let self = self else { return }
                        mapView.mapWindow.map.move(
                            with: YMKCameraPosition(
                                target: mapView.mapWindow.map.cameraPosition.target,
                                zoom: mapView.mapWindow.map.cameraPosition.zoom,
                                azimuth: mapView.mapWindow.map.cameraPosition.azimuth,
                                tilt: mapView.mapWindow.map.cameraPosition.tilt
                            ), animation: YMKAnimation(type: .linear, duration: 0.3)
                        )
                        isStartTimer = false
                    }
                }
                complition(nil)
                return
            }
            
            let address = self?.address.changeStreetAndHouse(city: "\(placemark.locality ?? "")", street: "\(placemark.thoroughfare ?? "")", house: "\(placemark.subThoroughfare ?? "")")

            complition(address)
        }
    }
    
    func onObjectTap(with event: YMKGeoObjectTapEvent) -> Bool {
        let geoObj = event.geoObject
        guard let point = geoObj.geometry.first?.point else {
            return false
        }
        for obj in self.geoJSONService.polygons {
            if obj.polygon.isCoordinateInsidePolygon(CLLocationCoordinate2D(latitude: point.latitude, longitude: point.longitude)) {
                let metadata = geoObj.metadataContainer.getItemOf(YMKGeoObjectSelectionMetadata.self)
                if let selectionMetadata = metadata as? YMKGeoObjectSelectionMetadata {
                    //if selectionMetadata.id.count > 6 {
                    mapView.mapWindow.map.move(
                        with: YMKCameraPosition(
                            target: point,
                            zoom: mapView.mapWindow.map.cameraPosition.zoom,
                            azimuth: mapView.mapWindow.map.cameraPosition.azimuth,
                            tilt: mapView.mapWindow.map.cameraPosition.tilt
                        ), animation: YMKAnimation(type: .linear, duration: 0.3)
                    )
                    mapView.mapWindow.map.selectGeoObject(withSelectionMetaData: selectionMetadata)
                    //}
                    convertCoordinateToAdress(point) { [weak self] address in
                        guard let address = address else { return }
                        
                        self?.bundleStatus = address.isStreetAndHouseFill ? .allowed : .unknown
                        self?.deliveryPrice = obj.price
                        self?.address = address
                    }
                    
                    return true
                }
            }
        }
        
        return false
    }
    
    func onMapTap(with map: YMKMap, point: YMKPoint) {
        mapView.mapWindow.map.deselectGeoObject()
    }
    
}

extension MapViewModel: YMKMapCameraListener {
    func onCameraPositionChanged(with map: YMKMap, cameraPosition: YMKCameraPosition, cameraUpdateReason: YMKCameraUpdateReason, finished: Bool) {
        if !isZoomChange {
            if finished {
                let point = YMKPoint(latitude: cameraPosition.target.latitude, longitude: cameraPosition.target.longitude)
                convertCoordinateToAdress(point) { [weak self] address in
                    guard let address = address, let self = self else { return }
                    
                    var flag = false
                    for obj in self.geoJSONService.polygons {
                        if obj.polygon.isCoordinateInsidePolygon(CLLocationCoordinate2D(latitude: point.latitude, longitude: point.longitude)) {
                            flag = true
                            if address.isStreetAndHouseFill {
                                
                                self.bundleStatus = .allowed
                                
                                guard self.address != address else { return }
                                
                                self.address = address
                                self.deliveryPrice = obj.price
                                
                            } else {
                                self.bundleStatus = .unknown
                                self.deliveryPrice = nil
                                self.address = self.address.changeStreetAndHouse(city: "", street: "", house: "")
                            }
                        }
                    }
                    
                    if !flag {
                        self.bundleStatus = address.isStreetAndHouseFill ? .forbidden : .unknown
                        self.deliveryPrice = nil
                        self.address = self.address.changeStreetAndHouse(city: "", street: "", house: "")
                    }
                }
            } else {
                
                if self.bundleStatus != .scrolled {
                    self.bundleStatus = .scrolled
                    self.deliveryPrice = nil
                    self.address = self.address.changeStreetAndHouse(city: "", street: "", house: "")
                }
            }
        } else {
            isZoomChange = false
        }
    }
    
    
}

//MARK: - UserIntents
extension MapViewModel {
    
    func plusZoom() {
        isZoomChange = true
        mapView.mapWindow.map.move(
            with: YMKCameraPosition(
                target: mapView.mapWindow.map.cameraPosition.target,
                zoom: mapView.mapWindow.map.cameraPosition.zoom + 1,
                azimuth: mapView.mapWindow.map.cameraPosition.azimuth,
                tilt: mapView.mapWindow.map.cameraPosition.tilt
            ), animation: YMKAnimation(type: .linear, duration: 0.3)
        )
    }
    
    func minusZoom() {
        isZoomChange = true
        mapView.mapWindow.map.move(
            with: YMKCameraPosition(
                target: mapView.mapWindow.map.cameraPosition.target,
                zoom: mapView.mapWindow.map.cameraPosition.zoom - 1,
                azimuth: mapView.mapWindow.map.cameraPosition.azimuth,
                tilt: mapView.mapWindow.map.cameraPosition.tilt
            ), animation: YMKAnimation(type: .linear, duration: 0.3)
        )
    }
    
    func moveToUserLocation() {
        guard let userLocation = userLocation else { return }
        mapView.mapWindow.map.move(
            with: YMKCameraPosition(
                target: YMKPoint(latitude: userLocation.latitude, longitude: userLocation.longitude),
                zoom: 17,
                azimuth: 0,
                tilt: 0
            ), animation: YMKAnimation(type: .linear, duration: 0.3)
        )
    }
}
