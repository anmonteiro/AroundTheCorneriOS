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
  var bookmarks : [SinglePlace]
  init() {
    // TODO: read from file and instantiate the array
    bookmarks = [SinglePlace(id: "1", name: "Club 11 e.V.", type: "Bar", ratings: [3, 4, 3, 4], photoURL: "placeTestImg",
    address: "Hochschulstraße 48, 01069 Dresden", phone: "0351 2644456", website: "http://clubelf.de", isOpenNow: false)]

  }
  
  func addBookmark(bookmark : SinglePlace) {
    // TODO: can the array ever contain the same?
    bookmarks.append(bookmark)
  }
  
  func removeBookmark(bookmark : SinglePlace) -> Bool {
    var index = -1
    
    for var i = 0; i < bookmarks.count; i++ {
      if bookmarks[i].id == bookmark.id {
        index = i
        break
      }
    }
    
    if index == -1 {
      return false
    }
    bookmarks.removeAtIndex(index)
    return true
  }
}