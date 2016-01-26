//
//  BookmarkViewController.swift
//  AroundTheCorner
//
//  Created by António Nuno Monteiro on 21/11/15.
//  Copyright © 2015 António Nuno Monteiro. All rights reserved.
//

import UIKit

class SinglePlaceViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
  var bookmark : SinglePlace? = nil
  
  @IBOutlet weak var placeImageView: UIImageView!
  @IBOutlet weak var placeTypeLabel: UILabel!
  @IBOutlet weak var tableView: UITableView!
  
  /****************************
   **                        **
   ** ViewController Methods **
   **                        **
   ****************************/
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.tableView.delegate = self
    self.tableView.dataSource = self
    
    self.setupNavigationItem()
    self.setupImageViewAndTypeLabel()
  }
  
  /***************************
   **                       **
   ** Subview Setup Methods **
   **                       **
   ***************************/
  
  func setupNavigationItem(){
    self.navigationItem.title = bookmark!.placeName
    let shareBtn = UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: "shareBookmark:")
    
    let favoriteBtnImgName = bookmark!.isBookmarked ? "bookmark-icon-filled" : "tabbar-bookmarks"
    
    let favoriteBtn = UIBarButtonItem(image: UIImage(named: favoriteBtnImgName), style: .Plain, target: self, action: "toggleBookmarked:")

    self.navigationItem.rightBarButtonItems = [shareBtn, favoriteBtn]
    
  }
  
  func setupImageViewAndTypeLabel() {
    // TODO: eventually change from "named:" to "contentsOfUrl:"
    self.placeImageView.image = UIImage(data: bookmark!.placePhoto)
    //self.placeImageView.image = UIImage(named: (bookmark?.placePhoto)!)
    
    self.placeTypeLabel.backgroundColor = UIColor(red: 255, green: 255, blue: 255, alpha: 0.6)
    self.placeTypeLabel.textAlignment = .Center
    self.placeTypeLabel.text = self.bookmark?.placeType
  }
  
  /***************************
   **                       **
   ** Target-Action Methods **
   **                       **
   ***************************/
  
  func onSegmentedControlChanged(sender: UISegmentedControl) {
    self.tableView.reloadData()
    
    // Scroll table view to top
    if self.tableView.numberOfRowsInSection(0) > 0 {
      let indexPath = NSIndexPath(forRow: 0, inSection: 0)
      self.tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Top, animated: false)
    }
  }
  
  func shareBookmark(sender: UIBarButtonItem) {
    
  }
  
  func toggleBookmarked(sender: UIBarButtonItem) {
    bookmark!.isBookmarked = !bookmark!.isBookmarked
    
    let isBookmarked = bookmark!.isBookmarked
    
    if isBookmarked {
      BookmarksManager.sharedInstance.addBookmark(bookmark!)
    } else {
      BookmarksManager.sharedInstance.removeBookmark(bookmark!)
    }
    
    
    let favoriteBtnImgName = isBookmarked ? "bookmark-icon-filled" : "tabbar-bookmarks"
    sender.image = UIImage(named: favoriteBtnImgName)
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "writeReviewSegue" {
      let nextController = segue.destinationViewController as! WriteReviewViewController
      nextController.place = bookmark!
    }
  }
  
  /*************************
   **                     **
   ** UITableView Methods **
   **                     **
   *************************/
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 6
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    var cell : UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("tableCellValue2")
    
    if cell == nil {
      cell = UITableViewCell(style: .Value2, reuseIdentifier: "tableCellValue2")
    }

    if indexPath.row == 0 {
      return cell!
    }
    
    let iconImgNames = ["icon-marker", "icon-phone", "icon-globe", "icon-clock", "icon-euro"]
    let cellValues = [bookmark!.address, bookmark!.phone, bookmark!.website, bookmark!.isOpenNow ? "Open today!" : "Closed", "≈ €3"]
    
    let attachment = NSTextAttachment()
    attachment.image = UIImage(named: iconImgNames[indexPath.row - 1])
    
    let attachmentStr = NSAttributedString(attachment: attachment)
    
    cell?.textLabel?.attributedText = attachmentStr
    cell?.detailTextLabel?.textAlignment
    cell?.detailTextLabel?.text = cellValues[indexPath.row - 1]
    return cell!
  }
}