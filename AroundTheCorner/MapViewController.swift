//
//  FirstViewController.swift
//  AroundTheCorner
//
//  Created by António Nuno Monteiro on 14/11/15.
//  Copyright © 2015 António Nuno Monteiro. All rights reserved.
//

import UIKit
import GoogleMaps

class MapViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {
  var locationManager = CLLocationManager()
  var recomputePlaces = true
  var didFindMyLocation = false
  var filters : [String]? = nil
  var radius : Int? = nil
  
  @IBOutlet weak var filterBtn: UIBarButtonItem!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    locationManager.delegate = self
    locationManager.requestWhenInUseAuthorization()
    
    //        let camera = GMSCameraPosition.cameraWithLatitude(-33.86,
    //            longitude: 151.20, zoom: 6)
    let mapView = GMSMapView(frame: self.view.bounds)
    
    mapView.settings.compassButton = true;
    //mapView.myLocationEnabled = true
    mapView.addObserver(self, forKeyPath: "myLocation", options: NSKeyValueObservingOptions.New, context: nil)
    mapView.padding = UIEdgeInsetsMake(64, 0, 64, 0)
    
    self.view = mapView
    mapView.delegate = self

    self.filterBtn.target = self
    self.filterBtn.action = "toFilterView:"
  }
  
  func toFilterView(sender: AnyObject) {
    self.performSegueWithIdentifier("toFilterViewSegue", sender: nil)
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "toFilterViewSegue" {
      let viewController = segue.destinationViewController as! FilterViewController
      viewController.mapViewControllerInstance = self
    }
    else if segue.identifier == "showSinglePlaceSegue" {
      let nextViewController = segue.destinationViewController as! SinglePlaceViewController
      let thePlace = sender as! SinglePlace
      nextViewController.bookmark = thePlace
    }
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    if filters == nil {
      filters = ["restaurant", "bar"]
    }
    if radius == nil {
      radius = 150
    }

    populateNearbyPlaces();
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  deinit {
    // TODO: causing a warning:
    // Attempting to load the view of a view controller while it is deallocating
    // is not allowed and may result in undefined behavior
    if let v = self.view as? GMSMapView {
      v.removeObserver(self, forKeyPath: "myLocation")
    }
  }
  
  func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
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
        
        mapView.settings.myLocationButton = true
        
        
        didFindMyLocation = true
        populateNearbyPlaces()
      }
    }
  }
  
  func populateNearbyPlaces() {
    let mapView = self.view as! GMSMapView
    
    if !recomputePlaces {
      return
    }
    
    if let loc = mapView.myLocation {
      ATCPlacesClient.getNearbyPlaces(withFilters: filters!, radius: radius!, location: loc.coordinate, callback: {
        (results) -> Void in
        
        mapView.clear()
        for place in results {
          let marker = GMSMarker()
          let location = place["geometry"]!!["location"]!!
          marker.position = CLLocationCoordinate2DMake(location["lat"]!! as! CLLocationDegrees, location["lng"]!! as! CLLocationDegrees)
          let iconImgData = NSData(contentsOfURL: NSURL(string: place["icon"]!! as! String)!)
          let iconImg = UIImage(data: iconImgData!)
          let scaledIconImg = UIImage(CGImage: (iconImg?.CGImage)!, scale: (iconImg?.scale)! * 2, orientation: (iconImg?.imageOrientation)!)
          marker.icon = scaledIconImg
          marker.title = place["name"]!! as! String
          marker.appearAnimation = kGMSMarkerAnimationPop
          marker.snippet = "More >>"
          marker.map = mapView
          marker.userData = place["place_id"] as! String
        }
      })
    }
  }
  
  func mapView(mapView: GMSMapView!, didTapInfoWindowOfMarker marker: GMSMarker!) {
    let placeID = marker.userData as! String
    ATCPlacesClient.getPlaceDetails(placeID: placeID, callback: {
      (result) -> Void in
      let address = result["formatted_address"] as! String
      let phone_nr = result["international_phone_number"]! != nil ? result["international_phone_number"] as! String : "-"
      let name = result["name"] as! String
      let openNow = result["opening_hours"]! != nil ? result["opening_hours"]!!["open_now"] as! Bool : false
      let type = result["types"]!![0] as! String
      let website = result["website"]! != nil ? result["website"] as! String : "-"
      
      let photoReference = result["photos"]! != nil ? result["photos"]!![0]!["photo_reference"]! as! String : ""
      
      ATCPlacesClient.getPlacePhoto(photoID: photoReference, maxHeight: 500, callback: {
        (placePhotoData) -> Void in
        
        let thePlace : SinglePlace
        
        let idx = BookmarksManager.sharedInstance.getBookmark(placeID)
        if idx != -1 {
          thePlace = BookmarksManager.sharedInstance.bookmarks[idx]
        }
        else {
          thePlace = SinglePlace(id: placeID, name: name, type: type, ratings: [Int](), photo: placePhotoData, address: address, phone: phone_nr, website: website, isOpenNow: openNow)
        }
        
        self.performSegueWithIdentifier("showSinglePlaceSegue", sender: thePlace)
      })
    })
  }
}

