//
//  UserLocation.swift
//  HackerBooksPro
//
//  Created by Jose Sanchez Rodriguez on 03/03/2017.
//  Copyright © 2017 Jose Sanchez Rodriguez. All rights reserved.
//

import Foundation
import MapKit

class MapPin : NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
    }
}
