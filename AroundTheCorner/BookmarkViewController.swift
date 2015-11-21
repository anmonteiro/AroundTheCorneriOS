//
//  BookmarkViewController.swift
//  AroundTheCorner
//
//  Created by António Nuno Monteiro on 21/11/15.
//  Copyright © 2015 António Nuno Monteiro. All rights reserved.
//

import UIKit

class BookmarkViewController : UIViewController {
    var bookmark : Bookmark? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewWillAppear(animated)
        print(self.navigationController)
//        self.navigationController.hi
        print(bookmark?.placeName)
        self.navigationController?.navigationBar.topItem?.title = bookmark!.placeName
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
}