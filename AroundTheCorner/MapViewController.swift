//
//  FirstViewController.swift
//  AroundTheCorner
//
//  Created by António Nuno Monteiro on 14/11/15.
//  Copyright © 2015 António Nuno Monteiro. All rights reserved.
//

import UIKit
import GoogleMaps

class MapViewController: UIViewController, CLLocationManagerDelegate {
    var locationManager = CLLocationManager()
    var didFindMyLocation = false

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
//        let camera = GMSCameraPosition.cameraWithLatitude(-33.86,
//            longitude: 151.20, zoom: 6)
        let mapView = GMSMapView(frame: CGRectZero)
        
        mapView.settings.compassButton = true;
        //mapView.myLocationEnabled = true
        mapView.addObserver(self, forKeyPath: "myLocation", options: NSKeyValueObservingOptions.New, context: nil)
        self.view = mapView
        
        /*
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(-33.86, 151.20)
        marker.title = "Sydney"
        marker.snippet = "Australia"
        marker.map = mapView
        */
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
//        print("view will appear")
//        if let mapView = self.view as? GMSMapView {
//            print("view is mapview")
//            if let currLoc = mapView.myLocation {
//                print("current location: \(currLoc)")
//                //mapView.animateToLocation(<#T##location: CLLocationCoordinate2D##CLLocationCoordinate2D#>)
//            }
//            else {
//                print("still waiting for user's location or not enabled.")
//            }
//        }
        
    }
    
    override func viewDidAppear(animated: Bool) {
        if let mapView = self.view as? GMSMapView {
            mapView.padding = UIEdgeInsetsMake(64, 0, 64, 0)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.AuthorizedWhenInUse {
            if let mapView = self.view as? GMSMapView {
                mapView.myLocationEnabled = true
            }
        }
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if !didFindMyLocation {
            let myLocation: CLLocation = change![NSKeyValueChangeNewKey] as! CLLocation
            if let mapView = self.view as? GMSMapView {
                let camPos = GMSCameraPosition.cameraWithTarget(myLocation.coordinate, zoom: 16.0)
                mapView.animateToCameraPosition(camPos)
//                mapView.camera = 
                
                mapView.settings.myLocationButton = true
            }
            
            didFindMyLocation = true
        }
    }

}

