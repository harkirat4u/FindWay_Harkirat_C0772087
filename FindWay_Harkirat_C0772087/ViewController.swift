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


    @IBOutlet weak var minusZoom: UIButton!
    @IBOutlet weak var addZoom: UIButton!
    @IBOutlet weak var FindWay: UIButton!
    @IBOutlet var pinDrop: UITapGestureRecognizer!
    
    @IBOutlet weak var transportation: UISegmentedControl!
    @IBOutlet weak var mapView: MKMapView!//outlet for mapView
    let locationManager  = CLLocationManager()
    let annotation = MKPointAnnotation()
    let destinationRequest = MKDirections.Request()
   
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        checklocationServices()}
    
    @IBAction func addZoom(_ sender: UIButton) {
     let newRegion=MKCoordinateRegion(center: mapView.region.center,span: MKCoordinateSpan(latitudeDelta: mapView.region.span.latitudeDelta*0.5, longitudeDelta: mapView.region.span.longitudeDelta*0.5));
     mapView.setRegion(newRegion, animated: true)
    }
    
    @IBAction func minusZoom(_ sender: UIButton) {
       let newRegion=MKCoordinateRegion(center: mapView.region.center,span: MKCoordinateSpan(latitudeDelta: mapView.region.span.latitudeDelta/0.5, longitudeDelta: mapView.region.span.longitudeDelta/0.5));
                      mapView.setRegion(newRegion,animated: true)
    }
    
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
            //locationManager.startUpdatingLocation()
    case .denied:
            break
    case .authorizedAlways:
            mapView.showsUserLocation = true
            centerViewOnUserLocation()
           // locationManager.startUpdatingLocation()
            break
    case .authorizedWhenInUse:
          mapView.showsUserLocation = true
          centerViewOnUserLocation()
          //locationManager.startUpdatingLocation()
            break
    case .restricted:
            break
    @unknown default:
            break
        }
    }
   
    @IBAction func myLocation(_ sender: UIButton) {
//        mylocation(_mylocation: locationManager.location!)
      
    }
   
    @IBAction func pinDrop(_ sender: UITapGestureRecognizer) {
        let newCoordinates = mapView.convert(sender.location(in: mapView), toCoordinateFrom: mapView)
        annotation.coordinate = newCoordinates
        annotation.title = "Pin Droped here"
        mapView.addAnnotation(annotation)
        mapView.removeAnnotations(mapView.annotations.filter { $0 !== mapView.userLocation })
        self.mapView.addAnnotation(annotation)
        print(newCoordinates)
       let alertController = UIAlertController(title: "route changes steps", message:
                     "select transpotation type then press direction change if transpotation type change again click direction button", preferredStyle: .alert)
                      alertController.addAction(UIAlertAction(title: "Done", style: .default))
                      self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func FindWay(_ sender: UIButton) {transportation.isHidden = false
        print(annotation.coordinate,"Button")
        let souceCordinate = (locationManager.location?.coordinate)!
        let destinationPlaceMark = MKPlacemark(coordinate: annotation.coordinate, addressDictionary:nil)
        let soucePlaceMark = MKPlacemark(coordinate: souceCordinate, addressDictionary: nil)
        let sourceItem = MKMapItem(placemark: soucePlaceMark)
        let destinationItem = MKMapItem(placemark: destinationPlaceMark)
        print(destinationItem)
        destinationRequest.source = sourceItem
        destinationRequest.destination = destinationItem
        destinationRequest.requestsAlternateRoutes = false
        //select transpotation type
        switch transportation.selectedSegmentIndex{
        case 0: destinationRequest.transportType = .walking
        
            break
        case 1:
            destinationRequest.transportType = .automobile
            break
        default:
            break
            
        }
        let direction = MKDirections(request: destinationRequest)
        direction.calculate { (response, error) in
        guard let response = response else {
        return}

            for route in response.routes{
        self.mapView.addOverlay(route.polyline)
                self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)}}
        self.mapView.delegate = self
            mapView.removeOverlays(mapView.overlays)}
    
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        renderer.strokeColor = UIColor.red
        
        return renderer
    }
  
}

extension ViewController:CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let region = MKCoordinateRegion.init(center: location.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(region, animated: true)
    }
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkAuthorization()
    }
    
    func centerViewOnUserLocation() {
    if let location = locationManager.location?.coordinate {
        let region = MKCoordinateRegion.init(center: location, latitudinalMeters: 10000, longitudinalMeters:10000)
        mapView.setRegion(region, animated: true)
    }

}
}


