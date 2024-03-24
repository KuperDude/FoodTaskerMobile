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
    @Published var address: Address
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
    
    init(address: Address) {
        
        self.address = address
        super.init()
        convertAddress()
        
        //if CLLocationManager.locationServicesEnabled() {
            self.manager.delegate = self
            
        //}
        addPolygon()
        addTapListener()
        mapView.mapWindow.map.isNightModeEnabled = true
        mapView.mapWindow.map.mapType = .vectorMap
        mapView.mapWindow.map.poiLimit = 0
        mapView.mapWindow.map.addCameraListener(with: self)
    }

    func addPolygon() {
        let geojsonString = "{\"type\":\"FeatureCollection\",\"metadata\":{\"name\":\"Москва\",\"creator\":\"Yandex Map Constructor\"},\"features\":[{\"type\":\"Feature\",\"id\":0,\"geometry\":{\"type\":\"Polygon\",\"coordinates\":[[[37.63726687841793,55.89912334681131],[37.611860994628735,55.90394535172936],[37.58645511083969,55.910502312491666],[37.565169100097485,55.910502312491666],[37.54765963964828,55.90876675475085],[37.53427005224592,55.907031119004],[37.51950717382797,55.902595251017445],[37.49410129003889,55.89121395544032],[37.48002505712875,55.887162176707015],[37.46354556494125,55.88291700045728],[37.443632845214694,55.88253105222963],[37.40449405126937,55.867089962688546],[37.39144778662093,55.84855251449343],[37.397627596191256,55.83889407557883],[37.39076114111312,55.814930746683935],[37.37084842138656,55.78940510305528],[37.36810183935531,55.76773379996804],[37.37565493994129,55.73055483055526],[37.3866412680663,55.712727295675194],[37.40998721533191,55.69372810443015],[37.42028689794913,55.678987650728295],[37.43607974462882,55.65764289903481],[37.45942569189446,55.63900519561456],[37.493071321777265,55.61103193451983],[37.5116107504882,55.596648986179034],[37.53427005224602,55.591205408245486],[37.56379580908194,55.583427552681684],[37.59400821142569,55.57681515835585],[37.62696719580072,55.57487012363236],[37.65786624365228,55.57292499214824],[37.68052554541008,55.57292499214824],[37.694258455566334,55.578760096321346],[37.71691775732413,55.58770556479417],[37.73957705908196,55.5950937555855],[37.79519534521481,55.62502107135412],[37.82128787451169,55.64172374889476],[37.84051394873043,55.653372545483585],[37.83982730322262,55.663465354598465],[37.83364749365229,55.680927502942666],[37.82815432958981,55.69566722242853],[37.83364749365229,55.70497364415119],[37.839140657714815,55.722029637926035],[37.84188723974606,55.74643770204049],[37.84257388525387,55.77624896961986],[37.839140657714815,55.80565063890641],[37.838454012207,55.821116250887535],[37.827467684081995,55.83039265581516],[37.73271060400387,55.87789937287051],[37.69975161962887,55.8937219865791],[37.670912508300745,55.89449365570387],[37.63726687841793,55.89912334681131]]]},\"properties\":{\"fill\":\"#ed4543\",\"fill_opacity\":0.6,\"stroke\":\"#ed4543\",\"stroke_width\":\"5\",\"stroke_opacity\":0.9}}]}"
        
        // Декодируем GeoJSON-строку в структуру FeatureCollection
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
                mapPolygon.fillColor = UIColor(_colorLiteralRed: 1, green: 0, blue: 0, alpha: 0.05)
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
        let strAddress = address.convertToString()
        if !strAddress.isEmpty {
            let geocoder = CLGeocoder()
            geocoder.geocodeAddressString(strAddress) { [weak self] placemarks, error in
                if error != nil {
                    print(error)
                }
                
                if let placemark = placemarks?.first, let coordinates: CLLocationCoordinate2D = placemark.location?.coordinate {
                    self?.mapView.mapWindow.map.move(with:
                        YMKCameraPosition(target: YMKPoint(latitude: coordinates.latitude, longitude: coordinates.longitude), zoom: 17, azimuth: 0, tilt: 0))
                    
//                    locationManager.stopUpdatingLocation()
                    
//                    if self?.polygon?.isCoordinateInsidePolygon(CLLocationCoordinate2D(latitude: coordinates.latitude, longitude: coordinates.longitude)) ?? false {
//                        
//                        guard let mapObjects = self?.mapView.mapWindow.map.mapObjects else { return }
//                        
//                        let placemark = mapObjects.addPlacemark(with: YMKPoint(latitude: coordinates.latitude, longitude: coordinates.longitude))
//                        placemark.opacity = 1
//                        placemark.isDraggable = false
//                        placemark.setIconWith(UIImage(named: "pin_customer")!,
//                                               style: YMKIconStyle(
//                            anchor: CGPoint(x: 0, y: 0) as NSValue,
//                            rotationType: YMKRotationType.rotate.rawValue as NSNumber,
//                            zIndex: 0,
//                            flat: true,
//                            visible: true,
//                            scale: 1.5,
//                            tappableArea: nil))
                        
//                        let metadata = geoObj.metadataContainer.getItemOf(YMKGeoObjectSelectionMetadata.self)
//                        if let selectionMetadata = metadata as? YMKGeoObjectSelectionMetadata {
//                            mapView.mapWindow.map.selectGeoObject(withObjectId: selectionMetadata.id, layerId: selectionMetadata.layerId)
////                        }
//                        /                        ///
//                    } else {
//                        print("NO ITS OUTSIDE OF POLYGON")
//                    }
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
        manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        manager.startUpdatingLocation()
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
            
            print(placemark)
                
                // Use the placemark to extract the address
            var address = self.address.changeStreetAndHouse(street: "\(placemark.thoroughfare ?? "")", house: "\(placemark.subThoroughfare ?? "")")
//            address.id = self.address.id
                
//            self.address = address
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
            
            print(mapView.mapWindow.map.mapObjects)
            
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
                print(selectionMetadata.id)
                print(selectionMetadata.layerId)
                if selectionMetadata.id.count > 6 {
                    mapView.mapWindow.map.move(
                        with: YMKCameraPosition(
                            target: point,
                            zoom: mapView.mapWindow.map.cameraPosition.zoom,
                            azimuth: mapView.mapWindow.map.cameraPosition.azimuth,
                            tilt: mapView.mapWindow.map.cameraPosition.tilt
                        ), animationType: YMKAnimation(type: .linear, duration: 0.3)
                    )
                    mapView.mapWindow.map.selectGeoObject(withObjectId: selectionMetadata.id, layerId: selectionMetadata.layerId)
                }
                convertCoordinateToAdress(point) { [weak self] address in
                    guard let address = address else { return }
                    
                    self?.bundleStatus = address.isStreetAndHouseFill ? .allowed : .unknown

                    self?.address = address
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
                    if address.isStreetAndHouseFill {
                        
                        self?.bundleStatus = .allowed
                        
                        guard self?.address != address else { return }
                        
                        print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
                        print(address)
                        
                        self?.address = address
                        
                    } else {
                        self?.bundleStatus = .unknown
                        guard let address = self?.address.changeStreetAndHouse(street: "", house: "") else { return }
                        self?.address = address
                    }
                } else {
                    self?.bundleStatus = address.isStreetAndHouseFill ? .forbidden : .unknown
                    guard let address = self?.address.changeStreetAndHouse(street: "", house: "") else { return }
                    self?.address = address
                }
            }
        } else {
            
            if self.bundleStatus != .scrolled {
                self.bundleStatus = .scrolled
                self.address = self.address.changeStreetAndHouse(street: "", house: "")
            }
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
