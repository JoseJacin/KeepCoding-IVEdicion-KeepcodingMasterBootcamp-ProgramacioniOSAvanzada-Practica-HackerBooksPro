//
//  NSUserDefaults.swift
//  HackerBooksPro
//
//  Created by Jose Sanchez Rodriguez on 02/03/2017.
//  Copyright © 2017 Jose Sanchez Rodriguez. All rights reserved.
//

import Foundation
import UIKit
import CoreData

extension UserDefaults {
    
    class func saveBookLastOpen(book: Book) {
        if let data = Book.archiveUriFrom(book: book) {
            UserDefaults.standard.set(data, forKey: constants.lastBookOpen)
        }
    }
    
    class func loadBookLastOpen(context: NSManagedObjectContext) -> Book? {
        if let uriDefault = UserDefaults.standard.object(forKey: constants.lastBookOpen) as? Data {
            return Book.bookFrom(archivedURI: uriDefault, context: context)
        }
        
        return nil
    }
}

