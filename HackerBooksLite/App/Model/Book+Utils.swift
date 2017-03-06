//
//  Book.swift
//  HackerBooksLite
//
//  Created by Jose Sanchez Rodriguez on 3/3/17.
//  Copyright © 2017 KeepCoding. All rights reserved.
//

import Foundation
import CoreData

extension Book {
    // MARK: - Initiators
    // Convenience Initialicer
    convenience init(title: String, coverUrl: String = "", pdfUrl: String = "", context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entity(forEntityName: Book.entity().name!, in: context)!
        
        self.init(entity: entity, insertInto: context)
        self.title = title
        self.coverUrl = coverUrl
        self.pdfUrl = pdfUrl
        
        saveContext(context: context)
    }
    
    //MARK: - Functions
    // Function that returns a book by title
    class func get(title: String, coverUrl: String = "", pdfUrl: String = "", context: NSManagedObjectContext?) -> Book {
        let fetchRequest = NSFetchRequest<Book>(entityName: Book.entity().name!)
        fetchRequest.fetchLimit = 1
        fetchRequest.fetchBatchSize = 1
        fetchRequest.predicate = NSPredicate(format: "(title == %@", title)
        
        do {
            let result = try context?.fetch(fetchRequest)
            guard let resp = result else{
                return Book.init(title: title, coverUrl: coverUrl, pdfUrl: pdfUrl, context: context!)
            }
            if(resp.count > 0){
                return resp.first!
            }else{
                return Book.init(title: title, coverUrl: coverUrl, pdfUrl: pdfUrl, context: context!)
            }
        } catch{
            return Book.init(title: title, coverUrl: coverUrl, pdfUrl: pdfUrl, context: context!)
        }
    }

    // Function that concatenates the authors
    var authorsString : String{
        get{
            var ret = ""
            for author in authors!{
                ret += (author as AnyObject).name + ",  "
            }
            return ret
        }
    }
    
    // Function that puts a book as a favorite
    class func setIsFavourite(booktag: BookTag, context: NSManagedObjectContext) -> Book{
        
        let book = Book.get(title: (booktag.book?.title)!, context: context)
        let tag = Tag.get(name: constants.favoritesBooks, context: context)
        let booktag = BookTag.get(book: book, tag: tag, context: context)
        
        book.isFavorite = !book.isFavorite
        
        if(!book.isFavorite){
            context.delete(booktag)
        }
        
        return book
        
    }
    
    class func from(array arr: [Book]) -> Set<Book>{
        var ret = Set<Book>()
        
        for book in arr{
            ret.insert(book)
        }
        
        return ret
    }
}
