//
//  BookmarksManager.swift
//  AroundTheCorner
//
//  Created by António Nuno Monteiro on 27/12/15.
//  Copyright © 2015 António Nuno Monteiro. All rights reserved.
//

import Foundation

class BookmarksManager {
  static let sharedInstance = BookmarksManager()
  var bookmarks : [SinglePlace]!
  var plistPath : String
  
  init() {
    let directorys : [String]? = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory,NSSearchPathDomainMask.AllDomainsMask, true)
    let directories:[String] = directorys!;
    let pathToFile = directories[0]; //documents directory
    let plistFile = "BookmarksArray.plist"
    self.plistPath = pathToFile.stringByAppendingString("/" + plistFile)
    
    bookmarks = readBookmarksFromDisk()
  }
  
  func readBookmarksFromDisk() -> [SinglePlace] {
    if let tempArr : [SinglePlace] = NSKeyedUnarchiver.unarchiveObjectWithFile(self.plistPath) as? [SinglePlace] {
      return tempArr
    }
    
    return [SinglePlace]()
  }
  
  func getBookmark(id : String) -> Int {
    for var i = 0; i < bookmarks.count; i++ {
      if bookmarks[i].id == id {
        return i
      }
    }
    
    return -1
  }
  
  func addBookmark(bookmark : SinglePlace) {
    // TODO: can the array ever contain the same?
    bookmarks.append(bookmark)
    self.flushToDisk()
  }
  
  func removeBookmark(bookmark : SinglePlace) -> Bool {
    let idx = self.getBookmark(bookmark.id)
    
    if idx == -1 {
      return false
    }
    
    bookmarks.removeAtIndex(idx)
    self.flushToDisk()
    
    return true
  }
  
  func flushToDisk() {
    NSKeyedArchiver.archiveRootObject(bookmarks, toFile: self.plistPath)
    //print("I wrote an array to the file at\n\(plistPath)")
  }
}