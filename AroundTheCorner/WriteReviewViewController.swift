//
//  WriteReviewViewController.swift
//  AroundTheCorner
//
//  Created by António Nuno Monteiro on 23/11/15.
//  Copyright © 2015 António Nuno Monteiro. All rights reserved.
//

import UIKit

class WriteReviewViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    var place : SinglePlace? = nil
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    /*************************
     **                     **
     ** UITableView Methods **
     **                     **
     *************************/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ATCUtils.removeNavBarBgAndShadow(self.navigationBar)
        self.navigationBar.topItem?.title = place?.placeName
        
        // TODO: setup "Submit" button
    }
    
    /*************************
     **                     **
     ** UITableView Methods **
     **                     **
     *************************/
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Select a rating"
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}