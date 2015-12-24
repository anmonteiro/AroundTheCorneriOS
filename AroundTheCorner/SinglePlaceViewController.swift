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
    @IBOutlet weak var howMuchBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
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
        self.setupSegmentedControl()
        self.setupHowMuchBtn()
    }
    
    /***************************
     **                       **
     ** Subview Setup Methods **
     **                       **
     ***************************/
    
    func setupNavigationItem(){
        self.navigationItem.title = bookmark!.placeName
        let shareBtn = UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: "shareBookmark:")
        
        // TODO: change the condition to actual value
        let favoriteBtnImgName = true ? "bookmark-icon-filled" : "tabbar-bookmarks"
        
        let favoriteBtn = UIBarButtonItem(image: UIImage(named: favoriteBtnImgName), style: .Plain, target: self, action: "favUnfavBookmark:")
        self.navigationItem.rightBarButtonItems = [shareBtn, favoriteBtn]

    }
    
    func setupImageViewAndTypeLabel() {
        // TODO: eventually change from "named:" to "contentsOfUrl:"
        self.placeImageView.image = UIImage(named: (bookmark?.placePhoto)!)
        
        self.placeTypeLabel.backgroundColor = UIColor(red: 255, green: 255, blue: 255, alpha: 0.5)
        self.placeTypeLabel.textAlignment = .Center
        self.placeTypeLabel.text = self.bookmark?.placeType
    }
    
    func setupHowMuchBtn() {
        // TODO: button border color to blue
        let buttonText: NSString = "How much did you pay?\ne.g.: price for 1 meal, 1 drink, 1 entry fee..."
        
        //getting the range to separate the button title strings
        let newlineRange: NSRange = buttonText.rangeOfString("\n")
        
        //getting both substrings
        var substring1: NSString = ""
        var substring2: NSString = ""
        
        if(newlineRange.location != NSNotFound) {
            substring1 = buttonText.substringToIndex(newlineRange.location)
            substring2 = buttonText.substringFromIndex(newlineRange.location)
        }
        
        //assigning diffrent fonts to both substrings
        let font : UIFont? = UIFont.systemFontOfSize(17.0)
        let attrString = NSMutableAttributedString(
            string: substring1 as String,
            attributes: [NSFontAttributeName : font!])
        
        let font1:UIFont? = UIFont.systemFontOfSize(11.0)
        let attrString1 = NSMutableAttributedString(
            string: substring2 as String,
            attributes: [NSFontAttributeName : font1!])
        
        //appending both attributed strings
        attrString.appendAttributedString(attrString1)
        
        howMuchBtn.titleLabel?.lineBreakMode = .ByWordWrapping
        howMuchBtn.titleLabel?.textAlignment = .Center
        howMuchBtn.setAttributedTitle(attrString, forState: .Normal)
    }
    
    func setupSegmentedControl() {
        self.segmentedControl.addTarget(self, action: "onSegmentedControlChanged:", forControlEvents: .ValueChanged)
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

    func favUnfavBookmark(sender: UIBarButtonItem) {
        
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
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Assume there are only two buttons in the segmented control
        if self.segmentedControl.selectedSegmentIndex == 0 {
            return 1
        }
        else {
            return 2
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if self.segmentedControl.selectedSegmentIndex == 0 {
            return nil
        }
        
        switch section {
            case 0: return "Google ratings"
            case 1: return "Around The Corner ratings"
            
            // will never be called
            default: return nil
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Assume there are only two buttons in the segmented control
        if self.segmentedControl.selectedSegmentIndex == 0 {
            return 5
        }
        else {
            if section == 0 {
                return 1
            }
            else {
                return 2
            }

        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell : UITableViewCell?

        // Assume there are only two buttons in the segmented control
        if self.segmentedControl.selectedSegmentIndex == 0 {
            cell = tableView.dequeueReusableCellWithIdentifier("tableCellValue2")
            if cell == nil {
                cell = UITableViewCell(style: .Value2, reuseIdentifier: "tableCellValue2")
            }

            let iconImgNames = ["icon-marker", "icon-phone", "icon-globe", "icon-clock", "icon-euro"]
            let cellValues = [bookmark!.address, bookmark!.phone, bookmark!.website, bookmark!.isOpenNow ? "Open today!" : "Closed", "≈ €3"]
            
            let attachment = NSTextAttachment()
            attachment.image = UIImage(named: iconImgNames[indexPath.row])

            let attachmentStr = NSAttributedString(attachment: attachment)
            
            cell?.textLabel?.attributedText = attachmentStr
            cell?.detailTextLabel?.textAlignment
            cell?.detailTextLabel?.text = cellValues[indexPath.row]
        }
        else {
            cell = tableView.dequeueReusableCellWithIdentifier("tableCellDefault")
            if cell == nil {
                cell = UITableViewCell(style: .Subtitle, reuseIdentifier: "tableCellDefault")
            }
            
            // TODO: disclosure indicator appears gray, change to blue
            cell?.accessoryType = .DisclosureIndicator
            // TODO: Add stars instead of the number
            if indexPath.section == 0 {
                // TODO: Add actual google ratings
                // Google ratings
                cell?.textLabel?.text = String((bookmark?.avgRating)!)
                cell?.detailTextLabel?.text = "From " + String((bookmark?.numRatings)!) + " user reviews"
            }
            else {
                // ATC ratings
                if indexPath.row == 0 {
                    cell?.textLabel?.text = String((bookmark?.avgRating)!)
                    cell?.detailTextLabel?.text = "From " + String((bookmark?.numRatings)!) + " user reviews"
                }
                else {
                    // TODO: Consider changing this to a simple button; would make things easier
                    cell = UITableViewCell(style: .Default, reuseIdentifier: "tableCellDefault")
                    cell?.accessoryType = .None
                    //cell?.indentationLevel = 4
                    cell?.textLabel?.textAlignment = .Center
                    cell?.detailTextLabel?.text = ""
                    cell?.detailTextLabel?.textAlignment = .Right
                    cell?.textLabel?.font = UIFont.systemFontOfSize(17.0, weight: UIFontWeightHeavy)
                    cell?.textLabel?.text = "Leave a review!"
                }
            }
        }
        
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if self.segmentedControl.selectedSegmentIndex == 0 {
            // Details tableview
        }
        else {
            // Reviews tableview
            if indexPath.section == 0 {
                // Google Ratings
            }
            else {
                if indexPath.row == 0 {
                    // ATC Ratings
                }
                else {
                    // "Leave a review"
                    // Assume row == 1 (2nd row)
                    self.performSegueWithIdentifier("writeReviewSegue", sender: self)
                }
            }
        }
    }
}