//
//  Constants.swift
//  HackerBooksLite
//
//  Created by Jose Sanchez Rodriguez on 3/3/17.
//  Copyright © 2017 KeepCoding. All rights reserved.
//

import Foundation

// MARK: - Constants
struct constants {
    // DataBase Name
    static let dbName = "HackerBooksLite"
    // Indicator if the app has already been executed before
    static let isFirstTimeLaunched = "isFirstTimeLaunched"
    // URL of Json File
    static let urlFileJSON = "https://t.co/K9ziV0z3SJ"
    // Sections
    static let favoritesBooks = "Favorites"
    static let lastReadingBook = "Last Opened"
    static let finishedBooks = "Finished Books"
    // Number of items to return
    static let fetchBatchSize = 20
    // Files
    static let defaultBookCover = "emptyBookCover"
    static let defaultPdf = "emptyPdf"
    static let pngExtension = "png"
    static let pdfExtension = "pdf"
    // Table View
    static let tableViewChanged = "tableViewChanged"
}
