//
//  Bookmark.swift
//  AroundTheCorner
//
//  Created by António Nuno Monteiro on 21/11/15.
//  Copyright © 2015 António Nuno Monteiro. All rights reserved.
//

import Foundation

class Bookmark {
    var placeName : String
    var placeType : String
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
    
    init(name : String, type : String, ratings : [Int]) {
        self.placeName = name
        self.placeType = type
        self.ratings = ratings
    }
    
    
}