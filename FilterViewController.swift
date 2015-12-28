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
  var stepper : ATCRadiusStepper? = nil
  
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
    let radiusValue = self.stepper!.value
    let filterDict = ["places" : places, "radius" : radiusValue]
    
    self.performSegueWithIdentifier("applyFiltersSegue", sender: filterDict)
  }
  
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "applyFiltersSegue" {
      //we know that sender is dictionary here.
      let filterDict = sender as! [String : AnyObject];
      let filters = filterDict["places"] as! Array<String>
      let radiusValue = filterDict["radius"] as! Int
      
      mapViewControllerInstance?.filters = filters
      mapViewControllerInstance?.radius = radiusValue
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
      // "search radius" stepper section
      // TODO: show 'm' unit
      let rect = CGRectMake(0, 0, cell.bounds.width, cell.bounds.height)
      let stepper = ATCRadiusStepper(frame: rect)
      
      self.stepper = stepper

      stepper.minimumValue = 0
      stepper.maximumValue = 50000
      
      stepper.value = Double((self.mapViewControllerInstance!.radius!))
      stepper.stepValue = 50

      cell.contentView.addSubview(stepper)
    }
    else {
      // place types section
      let filters = Array(placeTypes.keys)
      cell.textLabel?.text = filters[indexPath.row]
      if self.mapViewControllerInstance!.filters!.contains(placeTypes[filters[indexPath.row]]!) {
        tableView.selectRowAtIndexPath(indexPath, animated: false, scrollPosition: UITableViewScrollPosition.None)
      }
      
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
