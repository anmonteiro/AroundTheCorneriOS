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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showSingleBookmarkSegue" {
            print(navigationController)
//            let nextController = (segue.destinationViewController as! UINavigationController).topViewController as! BookmarkViewController
            let nextController = (segue.destinationViewController as! BookmarkViewController)
            //self.navigationController?.pushViewController(nextController, animated: true)
            //we know that sender is an NSIndexPath here.
            let row = (sender as! NSIndexPath).row;
            let bookmark = self.bookmarks[row]
            nextController.bookmark = bookmark
        }
    }
    
    /*************************
     **                     **
     ** UITableView Methods **
     **                     **
     *************************/
    
    // TODO: use actual bookmarks
    // dummy bookmark for now
    let bookmarks = [Bookmark(name: "Club 11 e.V.", type: "Bar", ratings: [3, 4, 3, 4])]
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookmarks.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        // 
        return nil
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = bookmarksTableView.dequeueReusableCellWithIdentifier("tableCell", forIndexPath: indexPath)
        
        cell.textLabel?.text = bookmarks[indexPath.row].placeName
        cell.detailTextLabel?.text = bookmarks[indexPath.row].placeType + " " + String(bookmarks[indexPath.row].avgRating)

        // TODO: change to blue
        cell.accessoryType = .DisclosureIndicator

        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // TODO: verify if this is still an issue -> https://forums.developer.apple.com/thread/24135
        self.performSegueWithIdentifier("showSingleBookmarkSegue", sender: indexPath)
    }

}

