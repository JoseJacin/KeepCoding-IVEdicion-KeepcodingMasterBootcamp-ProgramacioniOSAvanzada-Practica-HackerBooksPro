//
//  JSONProcessing.swift
//  HackerBook
//
//  Created by Jose Sanchez Rodriguez on 31/01/2017.
//  Copyright © 2017 Jose Sanchez Rodriguez. All rights reserved.
//

import Foundation
import UIKit
import CoreData

//MARK: - Functions

func jsonLoadFromData(dataInput data: Data) throws -> JSONArray{
    if let maybeArray = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? JSONArray,
        let array = maybeArray {
        return array
    }else{
        throw HackerBookError.wrongJsonFormat
    }
}

func decodeBooks(books json: JSONArray, context: NSManagedObjectContext) throws{
    let _ = try json.flatMap({try decodeBook(book: $0, context: context)})
}

func decodeBook(book json: JSONDictonary, context: NSManagedObjectContext) throws{
    var image = constants.defaultBookCover+"."+constants.pngExtension
    if let urlImageString = json["image_url"] as? String {
        image = urlImageString
    }
    
    var pdf = constants.defaultPdf+"."+constants.pdfExtension
    if let urlPDFString = json["pdf_url"] as? String{
        pdf = urlPDFString
    }
    
    guard let title = json["title"] as? String else{
        throw HackerBookError.wrongJsonFormat
    }
    
    let book = Book.get(title: title, coverUrl: image, pdfUrl: pdf, context: context)
    
    if let authorsString = json["authors"] as? String{
        let authors = Author.fromStringToSet(s: authorsString, context: context) as NSSet
        book.authors = authors
    }
    
    if let tagsString = json["tags"] as? String{
        let arr = tagsString.characters.split{$0 == ","}.map(String.init)
        for each in arr{
            let tag = Tag.get(name: each, context: context)
            let _ = BookTag.get(book: book, tag: tag, context: context)
        }
    }    
}
