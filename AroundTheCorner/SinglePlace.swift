//
//  Bookmark.swift
//  AroundTheCorner
//
//  Created by António Nuno Monteiro on 21/11/15.
//  Copyright © 2015 António Nuno Monteiro. All rights reserved.
//

import Foundation

class SinglePlace {
    var placeName : String
    var placeType : String
    var placePhoto : String
    var ratings : [Int]
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
    }
    var address : String
    var phone : String
    var website : String
    var isOpenNow : Bool
    
    init(name : String, type : String, ratings : [Int], photoURL : String, address : String,
        phone : String, website : String, isOpenNow : Bool) {
        self.placeName = name
        self.placeType = type
        self.ratings = ratings
        self.placePhoto = photoURL
        self.address = address
        self.phone = phone
        self.website = website
        self.isOpenNow = isOpenNow
    }
    
    
}