//
//  MapViewController.swift
//  HackerBooksPro
//
//  Created by Jose Sanchez Rodriguez on 27/02/2017.
//  Copyright © 2017 Jose Sanchez Rodriguez. All rights reserved.
//

import UIKit
import CoreData
import MapKit

class MapViewController: UIViewController {

    var fetchedResultsController: NSFetchedResultsController<Annotation>? = nil
    var locationManager : CLLocationManager?
    var location: CLLocation?
    
    var book: Book?
    
    var locationList: [MapPin]?
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populateLocationList()
        showLocationsCenteringRegion()
    }
        
    @IBAction func fitLocationsClick(_ sender: Any) {
        showLocationsCenteringRegion()
    }

    @IBAction func fitUser(_ sender: Any) {
        let authStatus = CLLocationManager.authorizationStatus()
        if authStatus == .notDetermined {
            locationManager?.requestWhenInUseAuthorization()
            return
        }
        
        let region = MKCoordinateRegionMakeWithDistance(mapView.userLocation.coordinate, 1000, 1000)
        mapView.setRegion(mapView.regionThatFits(region), animated: true)
    }
}
