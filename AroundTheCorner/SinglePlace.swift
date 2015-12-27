//
//  Bookmark.swift
//  AroundTheCorner
//
//  Created by António Nuno Monteiro on 21/11/15.
//  Copyright © 2015 António Nuno Monteiro. All rights reserved.
//

import Foundation

class SinglePlace : NSObject {
  var id : String
  var placeName : String
  var placeType : String
  var placePhoto : String
  
  /*var ratings : [Int]
  var numRatings : Int {
    get {
      return ratings.count
    }
  }
  var avgRating : Float {
    get {
      let sum = ratings.reduce(0, combine: +)
      
      return Float(sum) / Float(numRatings)
    }
  }*/
  var address : String
  var phone : String
  var website : String
  // TODO: this needs updated data when bookmarked
  var isOpenNow : Bool
  var isBookmarked : Bool
  
  init(id : String, name : String, type : String, ratings : [Int], photoURL : String, address : String,
    phone : String, website : String, isOpenNow : Bool) {
      self.id = id
      self.placeName = name
      self.placeType = type
      //self.ratings = ratings
      self.placePhoto = photoURL
      self.address = address
      self.phone = phone
      self.website = website
      self.isOpenNow = isOpenNow
      self.isBookmarked = false
  }
  
  init (coder aDecoder: NSCoder!) {
    self.id = aDecoder.decodeObjectForKey("id") as! String
    self.placeName = aDecoder.decodeObjectForKey("placeName") as! String
    self.placeType = aDecoder.decodeObjectForKey("placeType") as! String
    self.address = aDecoder.decodeObjectForKey("address") as! String
    self.phone = aDecoder.decodeObjectForKey("phone") as! String
    self.website = aDecoder.decodeObjectForKey("website") as! String
    self.isOpenNow = aDecoder.decodeBoolForKey("isOpenNow")
    // TODO: photo support
    self.placePhoto = ""
    // if it's being decoded, it means it's being read from local bookmarks
    self.isBookmarked = true
  }
  
  func encodeWithCoder(coder : NSCoder!) {
    coder.encodeObject(self.id, forKey: "id")
    coder.encodeObject(self.placeName, forKey: "placeName")
    coder.encodeObject(self.placeType, forKey: "placeType")
    coder.encodeObject(self.address, forKey: "address")
    coder.encodeObject(self.phone, forKey: "phone")
    coder.encodeObject(self.website, forKey: "website")
    coder.encodeBool(self.isOpenNow, forKey: "isOpenNow")
    
  }
}