//
//  Haversine.swift
//  SoonToBeNamed
//
//  Created by Darrell Cornelius Rivaldo on 22/06/25.
//

import Foundation
import SwiftUI
import CoreLocation

func haversine(p1: CLLocationCoordinate2D, p2: CLLocationCoordinate2D) -> Double {
    let R: Double = 6371
    let deltaLatitude = Angle(degrees: p2.latitude - p1.latitude).radians
    let deltaLongitude = Angle(degrees: p2.longitude - p2.longitude).radians
    let latitude1Radian = Angle(degrees: p1.self.latitude).radians
    let latitude2Radian = Angle(degrees: p2.self.latitude).radians
    
    let a = pow(sin(deltaLatitude / 2), 2) + cos(latitude1Radian) * cos(latitude2Radian) * pow(sin(deltaLongitude / 2), 2)
    let c = 2 * atan2(sqrt(a), sqrt(1 - a))
    
    return R * c
}
