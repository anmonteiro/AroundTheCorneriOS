//
//  FilterViewController.swift
//  AroundTheCorner
//
//  Created by António Nuno Monteiro on 14/11/15.
//  Copyright © 2015 António Nuno Monteiro. All rights reserved.
//

import UIKit

class FilterViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var filterTableView: UITableView!
    
    /****************************
     **                        **
     ** ViewController Methods **
     **                        **
     ****************************/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // remove navigationBar's background and shadow
        for parent in self.navigationBar!.subviews {
            for childView in parent.subviews {
                if(childView is UIImageView) {
                    childView.removeFromSuperview()
                }
            }
        }
        
        // associate the table view with this view controller
        self.filterTableView.delegate = self;
        self.filterTableView.dataSource = self;
    }
    
    /*************************
     **                     **
     ** UITableView Methods **
     **                     **
     *************************/
    
    var placeTypes = ["Bar", "Bakery", "Cafe", "Casino", "Convenience Store", "Grocery Store / Supermarket",
                      "Liquor Store", "Night Club", "Restaurant"]
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // the following assumes there are only 2 sections
        return section == 0 ? 1 : placeTypes.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        // the following assumes there are only 2 sections
        return section == 0 ? "Search radius" : "Place type"
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // the following assumes there are only 2 sections
        let cell = tableView.dequeueReusableCellWithIdentifier("tableCell", forIndexPath: indexPath)
        
        if indexPath.section == 0 {
            // "search radius" slider section
            let slider = UISlider()
            
            // TODO: fix images showing as black rectangle
            cell.contentView.addSubview(slider)
            let imgSize = CGSize(width: slider.bounds.size.height, height: slider.bounds.size.height)
            let minImage = ATCUtils.scaleUIImageToSize(UIImage(named: "slider-minus")!, size: imgSize)
            let maxImage = ATCUtils.scaleUIImageToSize(UIImage(named: "slider-plus")!, size: imgSize)
            slider.minimumValueImage = minImage
            slider.maximumValueImage = maxImage

            slider.bounds = CGRectMake(0, 0, cell.contentView.bounds.size.width - 10, slider.bounds.size.height)
            slider.center = CGPointMake(CGRectGetMidX(cell.contentView.bounds), CGRectGetMidY(cell.contentView.bounds))
            //slider.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        }
        else {
            // place types section
            // TODO: make cells in this section selectable
            cell.textLabel?.text = placeTypes[indexPath.row]
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        }
        
        return cell
    }
}
