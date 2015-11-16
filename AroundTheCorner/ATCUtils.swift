//
//  Utils.swift
//  AroundTheCorner
//
//  Created by António Nuno Monteiro on 15/11/15.
//  Copyright © 2015 António Nuno Monteiro. All rights reserved.
//

import Foundation

class ATCUtils {

    static func readConfigurationFor(keys keys : Array<String>) -> String? {
        var myDict: NSDictionary?

        if let plistPath = NSBundle.mainBundle().pathForResource("configuration", ofType: "plist") {
            myDict = NSDictionary(contentsOfFile: plistPath)
        }
        if var dict = myDict {
            
            for var i = 0; i < keys.count - 1; i++ {
                dict = dict[keys[i]]! as! NSDictionary
            }
            
            return dict[keys.last!]! as? String
            
        }
        return nil
    }
}