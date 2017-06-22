//
//  MapViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Sewon Park on 6/18/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Parse

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var customMapview: MKMapView!
    
    var locationManager = CLLocationManager()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
       
        if CLLocationManager.locationServicesEnabled(){

            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
            
            
        }
        
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        //User's current location and an annotation pin
        let userLocation: CLLocation = locations[0]
        
        let latitude = userLocation.coordinate.latitude
        
        let longitude = userLocation.coordinate.longitude
        
        let latDelta: CLLocationDegrees = 0.05
        
        let lonDelta: CLLocationDegrees = 0.05
        
        let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta)
        
        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        let region = MKCoordinateRegion(center: location, span: span)
        
        customMapview.setRegion(region, animated: true)
        
        
        let annotation = MKPointAnnotation()
        annotation.title = "You are here"
        
        annotation.subtitle = "stuff"
        
        annotation.coordinate = location
        
        customMapview.showsUserLocation = true
        customMapview.addAnnotation(annotation)
        customMapview.showAnnotations([annotation], animated: true)
        customMapview.delegate = self
        manager.stopUpdatingLocation()
        
        //upload coordinate data to aws
        
        let mapupload = PFObject(className: "Map")
        
        mapupload["latitude"] = latitude
        mapupload["longitude"] = longitude
        mapupload.saveInBackground { (success, error) in
            //create activity tracker and alert here, limit it to 1 set of coordinates and autodelete any locations older than latest, also map it to specific users
        }
        
        
    }
    
    
    
    
    
    
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
