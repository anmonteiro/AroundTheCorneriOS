//
//  FilterViewController.swift
//  AroundTheCorner
//
//  Created by António Nuno Monteiro on 14/11/15.
//  Copyright © 2015 António Nuno Monteiro. All rights reserved.
//

import UIKit

class FilterViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
  var mapViewControllerInstance : MapViewController? = nil
  
  @IBOutlet weak var navigationBar: UINavigationBar!
  @IBOutlet weak var filterTableView: UITableView!
  @IBOutlet weak var applyBtn: UIBarButtonItem!
  
  /****************************
   **                        **
   ** ViewController Methods **
   **                        **
   ****************************/
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    ATCUtils.removeNavBarBgAndShadow(self.navigationBar)
    
    // associate the table view with this view controller
    self.filterTableView.delegate = self;
    self.filterTableView.dataSource = self;
    self.filterTableView.allowsMultipleSelection = true;
    
    applyBtn.target = self
    applyBtn.action = "applyFilter:"
  }
  
  func applyFilter(sender: UIBarButtonItem) {
    var places = [String]()
    if let selectedRows = self.filterTableView.indexPathsForSelectedRows {
      let filterKeys = Array(self.placeTypes.keys)
      for ip in selectedRows {
        let idx = ip.row
        places.append(self.placeTypes[filterKeys[idx]]!)
      }
    }
    else {
      // TODO: what to do for empty selection?
    }
    self.performSegueWithIdentifier("applyFiltersSegue", sender: places)
  }
  
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "applyFiltersSegue" {
      //we know that sender is an array here.
      let filters = sender as! Array<String>;
      mapViewControllerInstance?.filters = filters
    }
  }

  
  /*************************
   **                     **
   ** UITableView Methods **
   **                     **
   *************************/
  
  var placeTypes = ["Bar" : "bar", "Bakery" : "bakery", "Cafe" : "cafe",
    "Casino" : "casino", "Convenience Store" : "convenience_store",
    "Grocery Store / Supermarket" : "grocery_or_supermarket",
    "Liquor Store" : "liquor_store", "Night Club" : "night_club",
    "Restaurant" : "restaurant"]
  
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
      let filters = Array(placeTypes.keys)
      cell.textLabel?.text = filters[indexPath.row]
      
      // TODO: make cells selected according to the configuration in MapView
      if cell.selected {
        cell.accessoryType = UITableViewCellAccessoryType.Checkmark
      }
      else {
        cell.accessoryType = UITableViewCellAccessoryType.None
      }
    }
    
    return cell
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let cell = tableView.cellForRowAtIndexPath(indexPath)!
    
    cell.accessoryType = UITableViewCellAccessoryType.Checkmark
    
  }
  
  func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
    let cell = tableView.cellForRowAtIndexPath(indexPath)!
    
    cell.accessoryType = UITableViewCellAccessoryType.None
  }
}
