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

class ViewController: UIViewController, MKMapViewDelegate,CLLocationManagerDelegate{

    @IBOutlet weak var mapView: MKMapView!//outlet for mapView
    let locationManager  = CLLocationManager()
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
    else{
            //comeback
        }
    }
    func checkAuthorization(){
        switch CLLocationManager.authorizationStatus(){
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        
        case .denied:
            break
        case .authorizedAlways:
            break
        case .authorizedWhenInUse:
          mapView.showsUserLocation = true

            break
        case .restricted:
    
            break
        @unknown default:
       
            break
        }
        
        
    }
    


    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //come back
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        //comeback
    }

}

