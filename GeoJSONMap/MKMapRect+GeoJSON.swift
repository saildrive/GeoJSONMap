//
//  MKMapRect+GeoJSON.swift
//  GeoJSONMap
//
//  Created by Maxim Volgin on 10/11/2018.
//  Copyright © 2018 Maxim Volgin. All rights reserved.
//

import CoreLocation
import MapKit

public extension MKMapRect {

    public static func boundingMapRect(for geometry: GJGeometry) -> MKMapRect {
        switch geometry {
        case .point(let coordinate):
            return boundingMapRect(for: [MKMapPoint(coordinate)])
        case .lineString(let coordinates):
            return boundingMapRect(for: coordinates.map { MKMapPoint($0) })
        }
    }
    
    public static func boundingMapRect(for feature: GJFeature) -> MKMapRect {
        return boundingMapRect(for: feature.geometry)
    }
    
    public static func boundingMapRect(for features: [GJFeature]) -> MKMapRect {
        let geometry: [GJGeometry] = features.map { $0.geometry }
        let points: [[MKMapPoint]] = geometry.map { geometry in
            switch geometry {
            case .point(let coordinate):
                return [MKMapPoint(coordinate)]
            case .lineString(let coordinates):
                return coordinates.map { MKMapPoint($0) }
            }
        }
        return boundingMapRect(for: points.flatMap { $0 })
    }

    public static func boundingMapRect(for featureCollections: [GJFeatureCollection]) -> MKMapRect {
        return boundingMapRect(for: featureCollections.flatMap { $0.features } )
    }
        
    public static func boundingMapRect(for points: [MKMapPoint]) -> MKMapRect {
        let xs = points.map { $0.x }
        let ys = points.map { $0.y }
        let minX = xs.min()!
        let minY = ys.min()!
        let maxX = xs.max()!
        let maxY = ys.max()!
        let origin = MKMapPoint(x: minX, y: minY)
        let size = MKMapSize(width: maxX - minX, height: maxY - minY)
        let rect = MKMapRect(origin: origin, size: size)
        return rect
    }
    
}
