//
//  NSUbiquitousKeyValueStore.swift
//  HackerBooksPro
//
//  Created by Jose Sanchez Rodriguez on 5/3/17.
//  Copyright © 2017 ERISCO. All rights reserved.
//

import Foundation
import CoreData

extension NSUbiquitousKeyValueStore{
    class func loadBookLastOpen(context: NSManagedObjectContext) -> Book?{
        let defaultValueStore = NSUbiquitousKeyValueStore.default()
        if let uriDefault = defaultValueStore.object(forKey: constants.lastBookOpen) as? Data {
            return Book.bookFrom(archivedURI: uriDefault, context: context)
        }
        return nil
    }
    
    class func saveBookLastOpen(book: Book) {
        let defaultValueStore = NSUbiquitousKeyValueStore.default()
        if let data = Book.archiveUriFrom(book: book) {
            defaultValueStore.set(data, forKey: constants.lastBookOpen)
        }
    }
}
