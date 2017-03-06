//
//  Annotation.swift
//  HackerBooksLite
//
//  Created by Jose Sanchez Rodriguez on 3/3/17.
//  Copyright © 2017 KeepCoding. All rights reserved.
//

import Foundation
import CoreData

extension Annotation{
    // MARK: - Initiators
    // Convenience Initialicer
    convenience init (book: Book, title: String, text: String, page: Int16 = 0, context: NSManagedObjectContext){
        
        let entity = NSEntityDescription.entity(forEntityName: Annotation.entity().name!, in: context)!
        
        self.init(entity: entity, insertInto: context)
        
        self.book = book
        self.creationDate = NSDate()
        self.modifiedDate = NSDate()
        self.title = title
        self.text = text
        self.page = page
        
        saveContext(context: context)
        
    }
    
    //MARK: - Functions
    // Function that returns a annotation according to the book
    class func get(id: NSManagedObjectID?, book: Book, title: String = "", text: String = "", page: Int16 = 0, context: NSManagedObjectContext?) -> Annotation{
        
        if (id == nil){
            return Annotation.init(book: book, title: title, text: text, context: context!)
        }
        
        if let obj = context?.object(with: id!) {
            return obj as! Annotation
        }else{
            return Annotation.init(book: book, title: title, text: text, context: context!)
        }
        
    }
    
    // Function that execute a fetch in Annotation with a section by attribute tag.proxyForSorting
    class func fetchController( book: Book, context: NSManagedObjectContext) -> NSFetchedResultsController<Annotation>{
        let fetchResultsController = NSFetchedResultsController(fetchRequest: Annotation.fetchRequest(book: book),
                                             managedObjectContext: context,
                                             sectionNameKeyPath: nil,
                                             cacheName: "Annotation")
        
        do {
            try fetchResultsController.performFetch()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        return fetchResultsController
    }
    
    // Function that retrieves the first XX records and sorts them by a modified Date (modifiedDate) and Name (title)
    class func fetchRequest(book: Book) -> NSFetchRequest<Annotation>{
        let fetchRequest = NSFetchRequest<Annotation>(entityName: Annotation.entity().name!)
        
        // Set the batch size to a suitable number.
        fetchRequest.fetchBatchSize = constants.fetchBatchSize
        
        let bookPredicate = NSPredicate(format: "(book == %@)",book)
        
        let predicate = NSCompoundPredicate(orPredicateWithSubpredicates: [bookPredicate])
        fetchRequest.predicate = predicate
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "modifiedDate", ascending: false),
                              NSSortDescriptor(key: "title", ascending: true)]
        
        return fetchRequest
        
    }
}

