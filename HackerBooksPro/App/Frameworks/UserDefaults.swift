//
//  UserDefaults.swift
//  HackerBooksLite
//
//  Created by Jose Sanchez Rodriguez on 3/3/17.
//  Copyright © 2017 KeepCoding. All rights reserved.
//

import Foundation
import UIKit
import CoreData

extension UserDefaults {
    // Function that stores the last workbook read in UserDefaults
    class func saveBookTagLastOpen(booktag: BookTag) {
        if let data = BookTag.archiveUriFrom(booktag: booktag) {
            UserDefaults.standard.set(data, forKey: constants.lastReadingBook)
        }
    }
    
    // Function that retrieves the last book read from UserDefaults
    class func loadBookLastOpen(context: NSManagedObjectContext) -> BookTag? {
        if let uriDefault = UserDefaults.standard.object(forKey: constants.lastReadingBook) as? Data {
            return BookTag.bookTagFrom(archivedURI: uriDefault, context: context)
        }
        
        return nil
    }
}
