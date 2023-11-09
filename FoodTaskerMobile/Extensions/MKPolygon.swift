//
//  MKPolygon.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 14.07.2023.
//

import Foundation
import MapKit

extension MKPolygon {
    
    /// Checks if the coordinate is within the polygon
    func isCoordinateInsidePolygon(_ coordinate: CLLocationCoordinate2D) -> Bool {
        let render = MKPolygonRenderer(polygon: self)
        let mapPoint = MKMapPoint(coordinate)
        let polygonViewPoint = render.point(for: mapPoint)

        return render.path.contains(polygonViewPoint)
    }
}
