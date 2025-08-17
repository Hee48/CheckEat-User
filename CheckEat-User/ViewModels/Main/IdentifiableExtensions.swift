//
//  IdentifiableExtensions.swift
//  CheckEat-User
//
//  Created by 최준영 on 8/17/25.
//

import Foundation
import CoreLocation

extension CLLocationCoordinate2D: Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}

extension Int: Identifiable {
    public var id: Int { self }
}
