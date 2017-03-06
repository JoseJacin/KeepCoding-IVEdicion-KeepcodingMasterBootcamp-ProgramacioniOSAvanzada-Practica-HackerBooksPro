//
//  CONSTANTS.swift
//  HackerBook
//
//  Created by Jose Sanchez Rodriguez on 03/02/2017.
//  Copyright © 2017 Jose Sanchez Rodriguez. All rights reserved.
//

import Foundation

struct constants {
    //MARK: - Database
    static let dbName = "HackerBooksPro"
    
    //MARK: - App
    // Indicator if the app has already been executed before
    static let isFirstTimeLaunched = "isFirstTimeLaunched"
    
    //MARK: - Resources
    static let urlFileJSON = "https://t.co/K9ziV0z3SJ"
    
    //MARK: - Files
    static let defaultBookCover = "HackerBooksPro-defaultBookCover"
    static let defaultPdf = "HackerBooksPro-defaultPdf"
    static let defaultAnnotationImage = "HackerBooksPro-defaultImageAnnotation"
    static let pngExtension = "png"
    static let pdfExtension = "pdf"
    
    // Sections
    static let favoritesBooks = "Favorites"
    static let lastReadingBook = "Last Opened"
    static let finishedBooks = "Finished Books"
    static let lastBookOpen = "lastBookOpen"
    
    //MARK: - Appearance
    static let fetchBatchSize = 20 // Number of items to return fetched
    static let sectionHeight = 30 // Height of section
    
    //MARK: - Controllers
    static let loadingController = "LoadingController"
    static let navigationController = "NavigationController"
    
    //MARK: - Views
    static let bookCell = "BookCell"
    static let sectionHeader = "SectionHeader"
    static let annotationCell = "AnnotationCell"
    
    //Storyboards
    static let main = "Main"

    // Notifications
    static let collectionViewChanged = "collectionViewChanged"
    static let annotationsViewChanged = "AnnotationsViewChanged"
    
    //MARK: - Location
    static let locationServiceDisabled = "Location Services Disabled"
    static let locationServiceDisabledMessage = "Please enable location services for this app in Settings"
    static let locationServiceDisabledOK = "OK"
    static let locationServiceTimedOut = "Location Services timed out"
    static let locationServiceTimedOutMessage = "Location service has triggered timed out!"
    static let locationServiceTimedOutOK = "OK"
    
}
