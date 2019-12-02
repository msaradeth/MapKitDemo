//
//  PinAnnotation.swift
//  MapKitDemo
//
//  Created by Mike Saradeth on 12/1/19.
//  Copyright © 2019 Mike Saradeth. All rights reserved.
//

import Foundation
import MapKit

class PinAnnotation : NSObject, MKAnnotation {
    var coordinate : CLLocationCoordinate2D
    var title: String?
    var calloutAnnotation: CustomBusinessCallOut?
    
    init(location coord:CLLocationCoordinate2D) {
        self.coordinate = coord
        super.init()
    }
}
