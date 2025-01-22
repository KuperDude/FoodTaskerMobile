//
//  GeoJSONService.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 13.12.2024.
//

import Foundation
import CoreLocation
import YandexMapsMobile
import MapKit

class GeoJSONService {
    
    static let instance = GeoJSONService()
    
    private init() {}
    
    var jsonData: Data?
    
    var polygons: [MKPolygonObj] = []
    var mapView = YMKMapView()
    
    func loadGeoJSON() async {
        do {
            let data = try await APIManager.instance.fetchGeoJSON()
            
            jsonData = data
            await MainActor.run {
                self.addPolygon()
            }
        } catch {
            jsonData = nil
        }
    }
    
    private func addPolygon() {
        
        guard let data = jsonData else { return }
        
        var geoJson = [MKGeoJSONObject]()
        do {
            
            geoJson = try MKGeoJSONDecoder().decode(data)
        } catch {
            print("Ошибка при декодировании GeoJSON: \(error)")
        }
        
        for item in geoJson {
            if let feature = item as? MKGeoJSONFeature {
                for geo in feature.geometry {
                    if let polygon = geo as? MKPolygon {
                        let obj = MKPolygonObj(polygon: polygon, price: nil)
                        self.polygons.append(obj)
                    }
                }
            }
        }
        
        // Декодируем GeoJSON-строку в структуру FeatureCollection
        let decoder = JSONDecoder()

        do {
            let featureCollection = try decoder.decode(FeatureCollection.self, from: data)
            var c = 0
            for feature in featureCollection.features {
                switch feature.geometry.coordinates {
                case .polygon(let polygons):
                    var coordinates = [YMKPoint]()
                    for polygon in polygons {
                        for point in polygon {
                            coordinates.append(YMKPoint(latitude: point[1], longitude: point[0]))
                        }
                    }
                    let mapPolygon = mapView.mapWindow.map.mapObjects.addPolygon(with: YMKPolygon(outerRing: YMKLinearRing(points: coordinates), innerRings: []))
                    mapPolygon.fillColor = UIColor(hex: feature.properties.fill ?? "#FFFFFF").withAlphaComponent(CGFloat(feature.properties.fill_opacity ?? 0.05))
                    mapPolygon.strokeColor = UIColor(hex: feature.properties.stroke ?? "#FFFFFF")
                    mapPolygon.strokeWidth = Float(Double(feature.properties.stroke_width ?? "1")!)
                    if let price = extractDeliveryPrice(from: feature.properties.description ?? "") {
                        self.polygons[c].price = price
                    }
                    if let restaurantTitle = extractRestaurantID(from: feature.properties.description ?? "") {
                        self.polygons[c].restaurantTitle = restaurantTitle
                    }
                    c+=1

                case .lineString(let lineString):
                    var coordinates = [YMKPoint]()
                    for point in lineString {
                        coordinates.append(YMKPoint(latitude: point[1], longitude: point[0]))
                    }
                    let polyline = mapView.mapWindow.map.mapObjects.addPolyline(with: YMKPolyline(points: coordinates))
                    polyline.strokeWidth = Float(Double(feature.properties.stroke_width ?? "1")!)

                case .point(let point):
                    let coordinate = YMKPoint(latitude: point[1], longitude: point[0])
                    let placemark = mapView.mapWindow.map.mapObjects.addPlacemark()
                    placemark.geometry = coordinate
                    
                    let iconStyle = YMKIconStyle()
                    iconStyle.scale = 0.3
                    iconStyle.anchor = NSValue(cgPoint: CGPoint(x: 0.5, y: 1.0))
                    
                    placemark.setIconWith(UIImage(named: "restaurant_placemark") ?? UIImage(), style: iconStyle)
                    placemark.opacity = 1.0
                    placemark.isDraggable = false
                }
            }
        } catch {
            print("Ошибка при декодировании GeoJSON: \(error)")
        }
    }

    private struct FeatureCollection: Codable {
        let features: [Feature]
    }

    private struct Feature: Codable {
        let geometry: Geometry
        let properties: Properties
    }

    struct Geometry: Codable {
        let type: String
        let coordinates: GeometryCoordinates
    }

    enum GeometryCoordinates: Codable {
        case polygon([[[Double]]])
        case lineString([[Double]])
        case point([Double])

        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()

            if let polygon = try? container.decode([[[Double]]].self) {
                self = .polygon(polygon)
            } else if let lineString = try? container.decode([[Double]].self) {
                self = .lineString(lineString)
            } else if let point = try? container.decode([Double].self) {
                self = .point(point)
            } else {
                throw DecodingError.dataCorruptedError(
                    in: container,
                    debugDescription: "Не удалось декодировать координаты"
                )
            }
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()

            switch self {
            case .polygon(let value):
                try container.encode(value)
            case .lineString(let value):
                try container.encode(value)
            case .point(let value):
                try container.encode(value)
            }
        }
    }


    private struct Properties: Codable {
        let description: String?
        let fill: String?
        let fill_opacity: Double?
        let stroke: String?
        let stroke_width: String?
        let stroke_opacity: Double?
        
        
        enum CodingKeys: String, CodingKey {
            case description
            case fill
            case fill_opacity = "fill-opacity"
            case stroke
            case stroke_width = "stroke-width"
            case stroke_opacity = "stroke-opacity"
        }
    }
    
    struct MKPolygonObj {
        var polygon: MKPolygon
        var price: Int?
        var restaurantTitle: String?
    }
    
    private func extractDeliveryPrice(from input: String) -> Int? {
        let pattern = "\\b(\\d+)\\sр"
        
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: [])
            let range = NSRange(input.startIndex..., in: input)
            
            if let match = regex.firstMatch(in: input, options: [], range: range),
               let priceRange = Range(match.range(at: 1), in: input) {
                let priceString = String(input[priceRange])
                return Int(priceString)
            }
        } catch {
            print("Invalid regex: \(error.localizedDescription)")
        }
        
        return nil
    }
    
    private func extractRestaurantID(from input: String) -> String? {
        let pattern = "^(.*?)\\s*-"
        if let match = input.range(of: pattern, options: .regularExpression) {
            let restaurantName = String(input[match])
                                    .replacingOccurrences(of: "-", with: "")
                                    .trimmingCharacters(in: .whitespaces)
            return restaurantName
        }
        return nil
    }
}


