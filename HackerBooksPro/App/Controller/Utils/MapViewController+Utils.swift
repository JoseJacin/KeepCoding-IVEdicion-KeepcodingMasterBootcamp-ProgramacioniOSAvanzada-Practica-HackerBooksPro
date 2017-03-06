//
//  MapViewController+Utils.swift
//  HackerBooksPro
//
//  Created by Jose Sanchez Rodriguez on 03/03/2017.
//  Copyright © 2017 Jose Sanchez Rodriguez. All rights reserved.
//

import Foundation
import MapKit

extension MapViewController: CLLocationManagerDelegate{
    
    func populateLocationList(){
        locationList = [MapPin]()
        if let objects = fetchedResultsController?.fetchedObjects{
            for each in objects {
                let annotation : Annotation = each as Annotation
                
                if let lng = annotation.location?.long,
                    let lat = annotation.location?.lat{
                    let coordinate = CLLocationCoordinate2DMake(lat, lng)
                    let mappin: MapPin = MapPin.init(coordinate: coordinate, title: annotation.title!, subtitle: "")
                    locationList?.append(mappin)
                }
            }
        }
    }
    
    func showLocationsCenteringRegion(){
        if let locationList = locationList {
            if(locationList.count > 0){
                var topLeft = CLLocationCoordinate2D(latitude: -90, longitude: 180)
                var bottomRight = CLLocationCoordinate2D(latitude: 80, longitude: -180)
                
                for location in locationList {
                    topLeft.latitude = max(topLeft.latitude, location.coordinate.latitude)
                    topLeft.longitude = min(topLeft.longitude, location.coordinate.longitude)
                    bottomRight.latitude = min(bottomRight.latitude, location.coordinate.latitude)
                    bottomRight.longitude = max(bottomRight.longitude, location.coordinate.longitude)
                }
                
                let centerLat = topLeft.latitude - (topLeft.latitude - bottomRight.latitude) / 2
                let centerLng = topLeft.longitude - (topLeft.longitude - bottomRight.longitude) / 2
                
                let center = CLLocationCoordinate2D(latitude: centerLat,longitude: centerLng)
                
                let addToBorder = 1.3
                
                let deltaLat = abs(topLeft.latitude - bottomRight.latitude) * addToBorder
                let deltaLng = abs(topLeft.longitude - bottomRight.longitude) * addToBorder
                
                let span = MKCoordinateSpan.init(latitudeDelta: deltaLat, longitudeDelta: deltaLng)
                
                let region = MKCoordinateRegion(center: center, span: span)
                
                mapView.addAnnotations(locationList)
                mapView.regionThatFits(region)
                mapView.setRegion(region, animated: true)
            }
        }
    }
}
