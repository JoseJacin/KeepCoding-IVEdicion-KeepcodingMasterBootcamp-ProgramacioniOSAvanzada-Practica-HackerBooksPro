//
//  BookTag.swift
//  HackerBooksLite
//
//  Created by Jose Sanchez Rodriguez on 3/3/17.
//  Copyright © 2017 KeepCoding. All rights reserved.
//

import Foundation
import CoreData

extension BookTag{
    // MARK: - Initiators
    // Convenience Initialicer
    convenience init(book: Book, tag: Tag, context: NSManagedObjectContext){
        let entity = NSEntityDescription.entity(forEntityName: BookTag.entity().name!, in: context)!
        
        self.init(entity: entity, insertInto: context)
        self.book = book
        self.tag = tag
        
    }
    
    //MARK: - Functions
    // Function that returns a relation by book and tag
    class func get(book: Book, tag: Tag, context: NSManagedObjectContext?) -> BookTag{
        let fetchRequest = NSFetchRequest<BookTag>(entityName: BookTag.entity().name!)
        fetchRequest.fetchLimit = 1
        fetchRequest.fetchBatchSize = 1
        fetchRequest.predicate = NSPredicate(format: "(book == %@) and (tag = %@)", book, tag)
        
        do{
            let result = try context?.fetch(fetchRequest)
            guard let resp = result else{
                return BookTag.init(book: book, tag: tag, context: context!)
            }
            if(resp.count > 0){
                return resp.first!
            }else{
                return BookTag.init(book: book, tag: tag, context: context!)
            }
        } catch{
            return BookTag.init(book: book, tag: tag, context: context!)
        }
    }
    
    // Function that returns the last book readed
    class func getLastOpened(context: NSManagedObjectContext) -> BookTag?{
        return UserDefaults.loadBookLastOpen(context: context)
    }
    
    // Function that store the last book readed
    class func setLastOpened(booktag: BookTag, context: NSManagedObjectContext){
        
        let tag = Tag.get(name: (booktag.tag?.name)!, context: context)
        let book = Book.get(title: (booktag.book?.title)!, context: context)
        let booktag = BookTag.get(book: book, tag: tag, context: context)
        
        UserDefaults.saveBookTagLastOpen(booktag: booktag)
    }
    
    // Return a NSData object which represents the BookTag
    class func archiveUriFrom(booktag: BookTag) -> Data? {
        let uri = booktag.objectID.uriRepresentation()
        return NSKeyedArchiver.archivedData(withRootObject: uri)
    }
    
    // Return a BookTag from NSData object
    class func bookTagFrom(archivedURI: Data, context: NSManagedObjectContext) -> BookTag? {
        if let uri: URL = NSKeyedUnarchiver.unarchiveObject(with: archivedURI) as? URL, let nid = context.persistentStoreCoordinator?.managedObjectID(forURIRepresentation: uri) {
            let booktag = context.object(with: nid) as! BookTag
            return booktag
        }
        
        return nil
    }
    
    // Function that execute a fetch in BookTag with a section by attribute tag.proxyForSorting
    class func fetchController(context: NSManagedObjectContext, text: String) -> NSFetchedResultsController<BookTag>{
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: BookTag.fetchRequest(text: text),
                                                                  managedObjectContext: context,
                                                                  sectionNameKeyPath: "tag.proxyForSorting",
                                                                  cacheName: "BookTag")
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        return fetchedResultsController
    }
    
    // Function that retrieves the first XX records and sorts them by a Proxy (tag.proxyForSorting) and Name (book.title)
    class func fetchRequest(text: String) -> NSFetchRequest<BookTag>{
        let fetchRequest = NSFetchRequest<BookTag>(entityName: BookTag.entity().name!)
        
        // Set the batch size to a suitable number.
        fetchRequest.fetchBatchSize = constants.fetchBatchSize
        
        if(text != ""){
            let t = text.lowercased()
            
            let tagPredicate = NSPredicate(format: "tag.name contains [cd] %@",t)
            let bookPredicate = NSPredicate(format: "book.title contains [cd] %@",t)
            let authorPredicate = NSPredicate(format: "book.authors.name contains [cd] %@",t)
            
            let predicate = NSCompoundPredicate(orPredicateWithSubpredicates: [tagPredicate,bookPredicate,authorPredicate])
            fetchRequest.predicate = predicate
            
        }
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "tag.proxyForSorting", ascending: true),
                                        NSSortDescriptor(key: "book.title", ascending: true)]
        
        return fetchRequest
    }
}

