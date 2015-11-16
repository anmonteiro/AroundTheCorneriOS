//
//  DismissSegue.swift
//  AroundTheCorner
//
//  Created by António Nuno Monteiro on 14/11/15.
//  Copyright © 2015 António Nuno Monteiro. All rights reserved.
//

import UIKit

@objc(DismissSegue) class DismissSegue : UIStoryboardSegue {
    override func perform() {
        let sourceVC = self.sourceViewController
        sourceVC.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
}