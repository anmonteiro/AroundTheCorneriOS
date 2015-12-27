//
//  SecondViewController.swift
//  AroundTheCorner
//
//  Created by António Nuno Monteiro on 14/11/15.
//  Copyright © 2015 António Nuno Monteiro. All rights reserved.
//

import UIKit

class BookmarkListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
  @IBOutlet weak var bookmarksTableView: UITableView!
  
  /****************************
   **                        **
   ** ViewController Methods **
   **                        **
   ****************************/
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    self.bookmarksTableView.delegate = self;
    self.bookmarksTableView.dataSource = self;
    
    // remove empty space at the top of the table view
    self.automaticallyAdjustsScrollViewInsets = false
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    bookmarksTableView.reloadData()
  }
  
  func click(sender: UIButton) {
    self.performSegueWithIdentifier("showSingleBookmarkSegue", sender: self)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "showSingleBookmarkSegue" {
      let nextController = (segue.destinationViewController as! SinglePlaceViewController)
      
      //we know that sender is an NSIndexPath here.
      let row = (sender as! NSIndexPath).row;
      let bookmark = BookmarksManager.sharedInstance.bookmarks[row]
      nextController.bookmark = bookmark
    }
  }
  
  /*************************
   **                     **
   ** UITableView Methods **
   **                     **
   *************************/
   
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return BookmarksManager.sharedInstance.bookmarks.count
  }
  
  func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    //
    return nil
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = bookmarksTableView.dequeueReusableCellWithIdentifier("tableCell", forIndexPath: indexPath)
    
    cell.textLabel?.text = BookmarksManager.sharedInstance.bookmarks[indexPath.row].placeName
    cell.detailTextLabel?.text = BookmarksManager.sharedInstance.bookmarks[indexPath.row].placeType + " " + "3.5"//String(bookmarks[indexPath.row].avgRating)
    
    // TODO: change to blue
    cell.accessoryType = .DisclosureIndicator
    
    return cell
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    // TODO: verify if this is still an issue -> https://forums.developer.apple.com/thread/24135
    // and: http://stackoverflow.com/questions/32643765
    self.performSegueWithIdentifier("showSingleBookmarkSegue", sender: indexPath)
  }
  
}

