//
//  ATCUtils.swift
//  AroundTheCorner
//
//  Created by António Nuno Monteiro on 15/11/15.
//  Copyright © 2015 António Nuno Monteiro. All rights reserved.
//

import Foundation
import UIKit

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
    
    static func scaleUIImageToSize(let image: UIImage, let size: CGSize) -> UIImage {
        let hasAlpha = false
        let scale: CGFloat = 0.0 // Automatically use scale factor of main screen
        
        UIGraphicsBeginImageContextWithOptions(size, !hasAlpha, scale)
        image.drawInRect(CGRect(origin: CGPointZero, size: size))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaledImage
    }
    
    static func removeNavBarBgAndShadow(navBar : UINavigationBar) {
        // remove navigationBar's background and shadow
        for parent in navBar.subviews {
            for childView in parent.subviews {
                if(childView is UIImageView) {
                    childView.removeFromSuperview()
                }
            }
        }
    }
}