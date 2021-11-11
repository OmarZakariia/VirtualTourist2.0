//
//  PinOnMap.swift
//  VirtualTourist2.0
//
//  Created by Zakaria on 11/11/2021.
//

import Foundation
import MapKit


class PinOnMap : NSObject, MKAnnotation{
    var coordinate: CLLocationCoordinate2D
    init(coordinate: CLLocationCoordinate2D){
        self.coordinate = coordinate
        
        super.init()
    }
}
