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

    @IBOutlet var pinDrop: UITapGestureRecognizer!
    @IBOutlet weak var myLocation: UIButton!
    @IBOutlet weak var mapView: MKMapView!//outlet for mapView
    let locationManager  = CLLocationManager()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.isZoomEnabled = false
        checklocationServices()}
    
    func setupLocationManager(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest}
    
    func checklocationServices(){
        if CLLocationManager.locationServicesEnabled(){
            setupLocationManager()
            checkAuthorization()}
    }
    
   
    
    func checkAuthorization(){
        switch CLLocationManager.authorizationStatus(){
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            mapView.showsUserLocation = true
          
            locationManager.startUpdatingLocation()
        case .denied:
            break
        case .authorizedAlways:
            mapView.showsUserLocation = true
            
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
   
    @IBAction func myLocation(_ sender: UIButton) {
        mylocation(_mylocation: locationManager.location!)
    }
   
    @IBAction func pinDrop(_ sender: UITapGestureRecognizer) {
        let newCoordinates = mapView.convert(sender.location(in: mapView), toCoordinateFrom: mapView)
        let annotation = MKPointAnnotation()
        annotation.coordinate = newCoordinates
        annotation.title = "Pin Droped here"
        mapView.addAnnotation(annotation)
        mapView.removeAnnotations(mapView.annotations.filter { $0 !== mapView.userLocation })
        self.mapView.addAnnotation(annotation)
        print(newCoordinates)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        renderer.strokeColor = UIColor.blue
        return renderer
    }
    
}



extension ViewController:CLLocationManagerDelegate{
    
    
  func mylocation(_mylocation: CLLocation){
      let location = locationManager.location!
      let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
      var region = MKCoordinateRegion(center: center, span: MKCoordinateSpan( latitudeDelta: 0.1, longitudeDelta: 0.1))
                   region.center = mapView.userLocation.coordinate
                   mapView.setRegion(region, animated: true)
       }
    
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkAuthorization()
    }

}

