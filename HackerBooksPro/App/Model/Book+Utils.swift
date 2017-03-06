//
//  Book+Utils.swift
//  HackerBooksPro
//
//  Created by Jose Sanchez Rodriguez on 24/02/2017.
//  Copyright © 2017 Jose Sanchez Rodriguez. All rights reserved.
//

import Foundation
import CoreData

extension Book {
    
    convenience init (title: String, coverUrl: String = "", pdfUrl: String = "", context: NSManagedObjectContext){
        let entity = NSEntityDescription.entity(forEntityName: Book.entity().name!, in: context)!
        
        self.init(entity: entity, insertInto: context)
        self.title = title
        self.coverUrl = coverUrl
        self.pdfUrl = pdfUrl
        
        saveContext(context: context)
    }
    
    class func get(title: String, coverUrl: String = "", pdfUrl: String = "", context: NSManagedObjectContext?) -> Book{
        let fr = NSFetchRequest<Book>(entityName: Book.entity().name!)
        fr.fetchLimit = 1
        fr.fetchBatchSize = 1
        fr.predicate = NSPredicate(format: "(title == %@)", title)
        do{
            let result = try context?.fetch(fr)
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
    
    var authorsString : String{
        get{
            var ret = ""
            for author in authors!{
                ret += (author as AnyObject).name + ", "
            }
            // Remove the last 2 character of the list (an extra ", ")
            //ret.remove(at: ret.index(before: ret.endIndex))
            //ret.remove(at: ret.index(before: ret.endIndex))
            return ret
        }
    }
    
    // Method is different from authorList because bookTags is a NSSet
    func tagsString() -> String? {
        
        var arrayOfTags = [String]()
        
        if let array = self.booktag?.allObjects as? [BookTag] {
            // go through the array except the pseudo "tags"
            for each in array where (!(each.tag?.name == constants.favoritesBooks) && !(each.tag?.name == constants.lastReadingBook)  && !(each.tag?.name == constants.finishedBooks)) {
                arrayOfTags.append((each.tag?.name?.capitalized)!)
            }
            arrayOfTags.sort()
            let list = arrayOfTags.joined(separator: ", ")
            
            return list
        }
        return nil
    }
    
    class func from(array arr: [Book]) -> Set<Book>{
        var ret = Set<Book>()
        
        for book in arr{
            ret.insert(book)
        }
        
        return ret
    }

    class func archiveUriFrom(book: Book) -> Data? {
        let uri = book.objectID.uriRepresentation()
        return NSKeyedArchiver.archivedData(withRootObject: uri)
    }
    
    class func bookFrom(archivedURI: Data, context: NSManagedObjectContext) -> Book? {
        if let uri: URL = NSKeyedUnarchiver.unarchiveObject(with: archivedURI) as? URL, let nid = context.persistentStoreCoordinator?.managedObjectID(forURIRepresentation: uri) {
            let book = context.object(with: nid) as! Book
            return book
        }
        
        return nil
    }
    
    class func setIsFavorite(book: Book, context: NSManagedObjectContext) -> Book{
        let tag = Tag.get(name: constants.favoritesBooks, context: context)
        let booktag = BookTag.get(book: book, tag: tag, context: context)
        
        book.isFavorite = !book.isFavorite
        
        if(!book.isFavorite){
            context.delete(booktag)
        }
        
        return book
    }

    // Function that gets the last open workbook from iCloud or from UserDefaults 
    class func getLastOpened(context: NSManagedObjectContext) -> Book? {
        var returnBook: Book? = nil
        
        if let lastOpened = NSUbiquitousKeyValueStore.loadBookLastOpen(context: context) {  
            returnBook = lastOpened
        }else if let lastOpened = UserDefaults.loadBookLastOpen(context: context) {
            returnBook = lastOpened
        }
        
        if let book = returnBook{
            return Book.get(title: book.title!, context: context)
        }
        
        return nil
    }
    
    class func setLastOpened(book: Book, context: NSManagedObjectContext){
        // Save to UserDefaults
        UserDefaults.saveBookLastOpen(book: book) 
        // Save to iCloud 
        NSUbiquitousKeyValueStore.saveBookLastOpen(book: book) 
    }
}
