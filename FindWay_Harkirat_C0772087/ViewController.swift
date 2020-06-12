//
//  ViewController.swift
//  FindWay_Harkirat_C0772087
//
//  Created by Harkirat singh on 2020-06-12.
//  Copyright © 2020 Harkirat singh. All rights reserved.
//

import UIKit
import MapKit //module for Mapview
import CoreLocation //module for to access location

class ViewController: UIViewController, MKMapViewDelegate{

    @IBOutlet weak var mapView: MKMapView!//outlet for mapView
    let locationManager  = CLLocationManager()
    let regionInMeters: Double = 10000
    override func viewDidLoad() {
        super.viewDidLoad()
        checklocationServices()
        // Do any additional setup after loading the view.
    }
    func setupLocationManager(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func checklocationServices(){
        if CLLocationManager.locationServicesEnabled(){
            setupLocationManager()
            checkAuthorization()
        }
    }
    
    func zoomeUserLocation(){
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)
        }
    }
    func checkAuthorization(){
        switch CLLocationManager.authorizationStatus(){
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            mapView.showsUserLocation = true
            zoomeUserLocation()
            locationManager.startUpdatingLocation()
        case .denied:
            break
        case .authorizedAlways:
            mapView.showsUserLocation = true
            zoomeUserLocation()
            break
        case .authorizedWhenInUse:
          mapView.showsUserLocation = true
          zoomeUserLocation()
            break
        case .restricted:
      
            break
        @unknown default:
            break
        }
    }
    
}



extension ViewController:CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //come back
        let location = locationManager.location!
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion.init(center: location.coordinate, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
                            mapView.setRegion(region, animated: true)
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkAuthorization()
     
    }

}

