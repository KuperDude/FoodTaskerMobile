//
//  MapManager.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 15.07.2023.
//

import Foundation
import CoreLocation
import YandexMapsMobile
import Combine
import MapKit
import SwiftUI

class MapViewModel: NSObject, ObservableObject {
    @ObservedObject var mainVM: MainViewModel
    @Published var bundleStatus: BundleStatus = .scrolled
    private var userLocation: CLLocationCoordinate2D?
    private let manager = CLLocationManager()
    
    var abv: AnyCancellable?
    
    var mapView = YMKMapView()

    
//    @Published var lastUserLocation: CLLocation? = nil
//    lazy var map: YMKMap = {
//        return mapView.mapWindow.map
//    }()
    
    var polygon: MKPolygon?
    
    init(mainVM: MainViewModel) {
        self.mainVM = mainVM
        super.init()
        if CLLocationManager.locationServicesEnabled() {
            self.manager.delegate = self
            self.manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            self.manager.startUpdatingLocation()
        }
        addPolygon()
        addTapListener()
        mapView.mapWindow.map.isNightModeEnabled = true
        mapView.mapWindow.map.mapType = .vectorMap
        mapView.mapWindow.map.poiLimit = 0
        mapView.mapWindow.map.addCameraListener(with: self)
    }

    func addPolygon() {
        let geojsonString = "{\"type\":\"FeatureCollection\",\"metadata\":{\"name\":\"Без названия\",\"creator\":\"Yandex Map Constructor\"},\"features\":[{\"type\":\"Feature\",\"id\":0,\"geometry\":{\"type\":\"Polygon\",\"coordinates\":[[[37.35016124111914,55.772907721982065],[37.41607920986913,55.62322098770122],[37.60971324307228,55.5617840978521],[37.77862803799413,55.575012851911914],[37.86651866299414,55.67059353235243],[37.861025498931646,55.82396391666571],[37.716143296783194,55.90427974347761],[37.54860179287696,55.92741678867818],[37.37831370693946,55.87649698223065],[37.35016124111914,55.772907721982065]]]},\"properties\":{\"fill\":\"#ed4543\",\"fill_opacity\":0.6,\"stroke\":\"#ed4543\",\"stroke_width\":\"5\",\"stroke_opacity\":0.9}}]}"
        // Декодируем GeoJSON-строку в структуру FeatureCollection
        guard let data = geojsonString.data(using: .utf8) else { return }
        let decoder = JSONDecoder()

        do {
            let featureCollection = try decoder.decode(FeatureCollection.self, from: data)

            // Перебираем все объекты GeoJSON и находим полигоны
            for feature in featureCollection.features {
                let polygon = feature.geometry
                // Создаем массив точек для полигона
                var coordinates = [YMKPoint]()
                for point in polygon.coordinates {
                    for coordinate in point {
                        coordinates.append(YMKPoint(latitude: coordinate[1], longitude: coordinate[0]))
                    }
                }

                // Создаем полигон на карте
                let mapPolygon = mapView.mapWindow.map.mapObjects.addPolygon(with: YMKPolygon(outerRing: YMKLinearRing(points: coordinates), innerRings: []))
                mapPolygon.strokeColor = UIColor(hex: feature.properties.fill)
                mapPolygon.strokeColor = UIColor(hex: feature.properties.stroke)
                mapPolygon.strokeWidth = Float(Double(feature.properties.stroke_width)!)

            }
        } catch {
            print("Ошибка при декодировании GeoJSON: \(error)")
        }
        
//        guard let url = Bundle.main.url(forResource: "map", withExtension: "json") else {
//            return
//        }
//
        var geoJson = [MKGeoJSONObject]()
        do {
            
            let data = geojsonString.data(using: .utf8) ?? Data()
            geoJson = try MKGeoJSONDecoder().decode(data)
        } catch {
            fatalError("")
        }
        
        for item in geoJson {
            if let feature = item as? MKGeoJSONFeature {
                for geo in feature.geometry {
                    if let polygon = geo as? MKPolygon {                        
                        self.polygon = polygon
                    }
                }
            }
        }
    }

    private struct FeatureCollection: Codable {
        let features: [Feature]
    }

    private struct Feature: Codable {
        let geometry: Geometry
        let properties: Properties
    }

    private struct Geometry: Codable {
        let type: String
        let coordinates: [[[Double]]]
    }

    private struct Properties: Codable {
        let fill: String
        let fill_opacity: Double
        let stroke: String
        let stroke_width: String
        let stroke_opacity: Double
        
//        enum CodingKeys: String, CodingKey {
//            case fill
//            case fill_opacity = "fill-opacity"
//            case stroke
//            case stroke_width = "fill-width"
//            case stroke_opacity = "stroke-opacity"
//        }
    }
    
    enum BundleStatus: String {
        case forbidden = "Доставка по данному адресу\n       временно недоступна"
        case allowed   = ""
        case unknown   = "Уточните адрес"
        case scrolled  = "\0"
    }
    
    func isPointInPolygon(_ point: YMKPoint) -> Bool {
        let coordinate = CLLocationCoordinate2D(latitude: point.latitude, longitude: point.longitude)
        return polygon?.isCoordinateInsidePolygon(coordinate) ?? false
    }
    
    
    func addTapListener() {
        mapView.mapWindow.map.addTapListener(with: self)
    }
    
    func convertAddress() {
        let strAddress = mainVM.address.convertToString()
        if !strAddress.isEmpty {
            let geocoder = CLGeocoder()
            geocoder.geocodeAddressString(strAddress) { [weak self] placemarks, error in
                if error != nil {
                    print(error)
                }
                
                if let placemark = placemarks?.first, let coordinates: CLLocationCoordinate2D = placemark.location?.coordinate {
                    self?.mapView.mapWindow.map.move(with:
                        YMKCameraPosition(target: YMKPoint(latitude: coordinates.latitude, longitude: coordinates.longitude), zoom: 14, azimuth: 0, tilt: 0))
                    
//                    locationManager.stopUpdatingLocation()
                    
                    if self?.polygon?.isCoordinateInsidePolygon(CLLocationCoordinate2D(latitude: coordinates.latitude, longitude: coordinates.longitude)) ?? false {
                        
                        guard let mapObjects = self?.mapView.mapWindow.map.mapObjects else { return }
                        
                        let placemark = mapObjects.addPlacemark(with: YMKPoint(latitude: coordinates.latitude, longitude: coordinates.longitude))
                        placemark.opacity = 1
                        placemark.isDraggable = false
                        placemark.setIconWith(UIImage(named: "pin_customer")!,
                                               style: YMKIconStyle(
                            anchor: CGPoint(x: 0, y: 0) as NSValue,
                            rotationType: YMKRotationType.rotate.rawValue as NSNumber,
                            zIndex: 0,
                            flat: true,
                            visible: true,
                            scale: 1.5,
                            tappableArea: nil))
                        
//                        let metadata = geoObj.metadataContainer.getItemOf(YMKGeoObjectSelectionMetadata.self)
//                        if let selectionMetadata = metadata as? YMKGeoObjectSelectionMetadata {
//                            mapView.mapWindow.map.selectGeoObject(withObjectId: selectionMetadata.id, layerId: selectionMetadata.layerId)
////                        }
                        ///                        ///
                    } else {
                        print("NO ITS OUTSIDE OF POLYGON")
                    }
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
}

extension MapViewModel: YMKLayersGeoObjectTapListener {
    
    private func convertCoordinateToAdress(_ coordinate: YMKPoint, complition: @escaping (Address?)->Void) {
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)

        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            guard let placemark = placemarks?.first, error == nil else {
                // Handle error if any
                complition(nil)
                return
            }
                
                // Use the placemark to extract the address
            let address = self.mainVM.address.changeStreetAndHouse(street: "\(placemark.thoroughfare ?? "")", house: "\(placemark.subThoroughfare ?? "")")
                
            //self.address = address
//            print(address)
            complition(address)
        }
    }
    
    func onObjectTap(with event: YMKGeoObjectTapEvent) -> Bool {
        let geoObj = event.geoObject
        guard let point = geoObj.geometry.first?.point else {
            return false
        }
        
        if polygon?.isCoordinateInsidePolygon(CLLocationCoordinate2D(latitude: point.latitude, longitude: point.longitude)) ?? false {
            
            let mapObjects = mapView.mapWindow.map.mapObjects
            
            mapView.mapWindow.map.move(
                with: YMKCameraPosition(
                    target: point,
                    zoom: mapView.mapWindow.map.cameraPosition.zoom,
                    azimuth: mapView.mapWindow.map.cameraPosition.azimuth,
                    tilt: mapView.mapWindow.map.cameraPosition.tilt
                ), animationType: YMKAnimation(type: .linear, duration: 0.3)
            )
            
//            let placemark = mapObjects.addPlacemark(with: point)
//            placemark.opacity = 1
//            placemark.isDraggable = false
//            placemark.setIconWith(UIImage(named: "pin_customer")!,
//                                   style: YMKIconStyle(
//                anchor: CGPoint(x: 0, y: 0) as NSValue,
//                rotationType: YMKRotationType.rotate.rawValue as NSNumber,
//                zIndex: 0,
//                flat: true,
//                visible: true,
//                scale: 1.5,
//                tappableArea: nil))
            
            let metadata = geoObj.metadataContainer.getItemOf(YMKGeoObjectSelectionMetadata.self)
            if let selectionMetadata = metadata as? YMKGeoObjectSelectionMetadata {
                print(selectionMetadata)
                mapView.mapWindow.map.selectGeoObject(withObjectId: selectionMetadata.id, layerId: selectionMetadata.layerId)
                convertCoordinateToAdress(point) { [weak self] address in
                    guard let address = address else { return }
                    
                    self?.bundleStatus = address.isStreetAndHouseFill ? .allowed : .unknown
                    
                    self?.mainVM.address = address
                }
                
                return true
            }
            
        } else {
            print("NO ITS OUTSIDE OF POLYGON")
        }
        
        return false
        
        // покажем пин
//            let placemark = mapObjects.addPlacemark(with: point).useCompositeIcon()
//            placemark.setIconWithName("pin_customer",
//                                         image: UIImage(named: "pin_customer")!,
//                style:YMKIconStyle(
//                    anchor: CGPoint(x: 0, y: 0) as NSValue,
//                    rotationType:YMKRotationType.rotate.rawValue as NSNumber,
//                    zIndex: 0,
//                    flat: true,
//                    visible: true,
//                    scale: 1.5,
//                    tappableArea: nil))
        //mapView.mapWindow.worldToScreen(withWorldPoint: point)

//            placemark1.setIconWith(UIImage(named: "pin_customer")!)
//            placemark1.setIconStyleWith(YMKIconStyle(
//                anchor: CGPoint(x: 0, y: 0) as NSValue,
//                rotationType: YMKRotationType.rotate.rawValue as NSNumber,
//                zIndex: 0,
//                flat: true,
//                visible: true,
//                scale: 1.5,
//                tappableArea: nil)
//            )
    }
    
    func onMapTap(with map: YMKMap, point: YMKPoint) {
        mapView.mapWindow.map.deselectGeoObject()
    }
    
}

extension MapViewModel: YMKMapCameraListener {
    func onCameraPositionChanged(with map: YMKMap, cameraPosition: YMKCameraPosition, cameraUpdateReason: YMKCameraUpdateReason, finished: Bool) {        
        if finished {
            let point = YMKPoint(latitude: cameraPosition.target.latitude, longitude: cameraPosition.target.longitude)
            convertCoordinateToAdress(point) { [weak self] address in
                guard let address = address else { return }
                
                if self?.polygon?.isCoordinateInsidePolygon(CLLocationCoordinate2D(latitude: point.latitude, longitude: point.longitude)) ?? false {
                    self?.bundleStatus = address.isStreetAndHouseFill ? .allowed : .unknown
                } else {
                    self?.bundleStatus = (cameraPosition.target.latitude == 0 && cameraPosition.target.longitude == 0) ? .scrolled : .forbidden
                }
                
                guard self?.mainVM.address != address else { return }
                
                self?.mainVM.address = address
            }
        } else {
            bundleStatus = .scrolled
        }
    }
    
    
}

//MARK: - UserIntents
extension MapViewModel {
    
    func plusZoom() {
        mapView.mapWindow.map.move(
            with: YMKCameraPosition(
                target: mapView.mapWindow.map.cameraPosition.target,
                zoom: mapView.mapWindow.map.cameraPosition.zoom + 1,
                azimuth: mapView.mapWindow.map.cameraPosition.azimuth,
                tilt: mapView.mapWindow.map.cameraPosition.tilt
            ), animationType: YMKAnimation(type: .linear, duration: 0.3)
        )
    }
    
    func minusZoom() {
        mapView.mapWindow.map.move(
            with: YMKCameraPosition(
                target: mapView.mapWindow.map.cameraPosition.target,
                zoom: mapView.mapWindow.map.cameraPosition.zoom - 1,
                azimuth: mapView.mapWindow.map.cameraPosition.azimuth,
                tilt: mapView.mapWindow.map.cameraPosition.tilt
            ), animationType: YMKAnimation(type: .linear, duration: 0.3)
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
            ), animationType: YMKAnimation(type: .linear, duration: 0.3)
        )
    }
}
