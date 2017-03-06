//
//  Errors.swift
//  HackerBooksPro
//
//  Created by Jose Sanchez Rodriguez on 24/02/2017.
//  Copyright © 2017 Jose Sanchez Rodriguez. All rights reserved.
//

import Foundation

enum HackerBookError : Error{
    case wrongUrlFormatForJSONResource
    case resourcePointedByUrlNotReachable
    case wrongJsonFormat
    case NotInLibrary
}

enum PDFError: Error{
    case invalidURL
    case notAPDF
}