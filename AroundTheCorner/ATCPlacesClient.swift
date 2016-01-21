//
//  ATCPlacesClient.swift
//  AroundTheCorner
//
//  Created by António Nuno Monteiro on 15/11/15.
//  Copyright © 2015 António Nuno Monteiro. All rights reserved.
//

import GoogleMaps

class ATCPlacesClient {
  static let noPhotoData = UIImageJPEGRepresentation(UIImage(named: "no_photo")!, 1.0)
  static let GPlacesAPIKey = ATCUtils.readConfigurationFor(keys: ["GooglePlacesAPI", "APIKey"])
  static let session = NSURLSession(configuration:
    NSURLSessionConfiguration.defaultSessionConfiguration())
  
  static func getNearbyPlaces(withFilters filters : [String], radius : Int, location : CLLocationCoordinate2D, callback : ((result: [AnyObject]) -> Void)) {
    let filtersString = filters.joinWithSeparator("|")
    // TODO: follow pages if more than 20 results
    let urlString = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?types=\(filtersString)&location=\(location.latitude),\(location.longitude)&radius=\(radius)&key=\(GPlacesAPIKey!)".stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
    if let url = NSURL(string: urlString) {
      let task = session.dataTaskWithURL(url, completionHandler: {
        (responseData, urlResponse, error) -> Void in
        // in case of error the array will be returned empty
        var results = [AnyObject]()
        if responseData != nil {
          if let jsonResult = try? NSJSONSerialization.JSONObjectWithData(responseData!, options: .MutableContainers) as! [String:AnyObject] {
            results = jsonResult["results"] as! [AnyObject]
          } else {
            print("Unexpected error parsing JSON!")
          }
        }
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
          callback(result: results)
        })
      })
      task.resume()
    }
  }
  
  static func getPlaceDetails(placeID id : String, callback : ((result: AnyObject?) -> Void)) {
    let urlString = "https://maps.googleapis.com/maps/api/place/details/json?key=\(GPlacesAPIKey!)&placeid=\(id)".stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
    if let url = NSURL(string: urlString) {
      let task = session.dataTaskWithURL(url, completionHandler: {
        (responseData, urlResponse, error) -> Void in
        // in case of error the result constant will contain a nil value
        let result : AnyObject?
        if responseData != nil {
          if let jsonResult = try? NSJSONSerialization.JSONObjectWithData(responseData!, options: .MutableContainers) as! [String:AnyObject] {
            result = jsonResult["result"]! as AnyObject
          } else {
            print("Unexpected error parsing JSON!")
            result = nil
          }
        } else {
          result = nil
        }
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
          callback(result: result)
        })
      })
      task.resume()
    }
  }
  
  static func getPlacePhoto(photoID id : String, maxHeight : Int, callback : ((result: NSData?) -> Void)) {
    if id == "" {
      callback(result: noPhotoData!)
    }
    else {
      let urlString = "https://maps.googleapis.com/maps/api/place/photo?key=\(GPlacesAPIKey!)&photoreference=\(id)&maxheight=\(maxHeight)".stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
      if let url = NSURL(string: urlString) {
        let task = session.dataTaskWithURL(url, completionHandler: {
          (responseData, urlResponse, error) -> Void in
          let result : NSData?
          if responseData != nil {
            result = responseData
          } else {
            print("Unexpected error getting place photo!")
            result = nil
          }
          dispatch_async(dispatch_get_main_queue(), { () -> Void in
            callback(result: result)
          })
        })
        task.resume()
      }
    }
  }
}
