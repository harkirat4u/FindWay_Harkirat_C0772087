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

    @IBOutlet weak var FindWay: UIButton!
    @IBOutlet var pinDrop: UITapGestureRecognizer!
    @IBOutlet weak var myLocation: UIButton!
    @IBOutlet weak var mapView: MKMapView!//outlet for mapView
    let locationManager  = CLLocationManager()
     let annotation = MKPointAnnotation()
    let destinationRequest = MKDirections.Request()
   
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
        annotation.coordinate = newCoordinates
        annotation.title = "Pin Droped here"
        mapView.addAnnotation(annotation)
        mapView.removeAnnotations(mapView.annotations.filter { $0 !== mapView.userLocation })
        self.mapView.addAnnotation(annotation)
        print(newCoordinates)
    }
    
    @IBAction func FindWay(_ sender: UIButton) {
        print(annotation.coordinate,"Button")
        let souceCordinate = (locationManager.location?.coordinate)!
        let destinationPlaceMark = MKPlacemark(coordinate: annotation.coordinate, addressDictionary:nil)
        let soucePlaceMark = MKPlacemark(coordinate: souceCordinate, addressDictionary: nil)
        let sourceItem = MKMapItem(placemark: soucePlaceMark)
        let destinationItem = MKMapItem(placemark: destinationPlaceMark)
        print(destinationItem)
        destinationRequest.source = sourceItem
        destinationRequest.destination = destinationItem
        destinationRequest.transportType = .automobile
        destinationRequest.requestsAlternateRoutes = true
        
        let direction = MKDirections(request: destinationRequest)
        direction.calculate { (response, error) in
        guard let response = response else {
        if error != nil {}
        return}
        let route = response.routes[0]
        self.mapView.addOverlay(route.polyline)
        self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)}
        self.mapView.delegate = self
        mapView.removeOverlays(mapView.overlays)}
    
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        renderer.strokeColor = UIColor.red
        return renderer
    }
    
}



extension ViewController:CLLocationManagerDelegate{
    
    
  func mylocation(_mylocation: CLLocation){
      let location = locationManager.location!
      let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
      var region = MKCoordinateRegion(center: center, span: MKCoordinateSpan( latitudeDelta: 0.2, longitudeDelta: 0.2))
                   region.center = mapView.userLocation.coordinate
                   mapView.setRegion(region, animated: true)
       }
    
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkAuthorization()
    }

}


