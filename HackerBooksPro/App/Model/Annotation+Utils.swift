//
//  Annotation.swift
//  HackerBooksPro
//
//  Created by Jose Sanchez Rodriguez on 02/03/2017.
//  Copyright © 2017 Jose Sanchez Rodriguez. All rights reserved.
//

import Foundation
import CoreData

extension Annotation{
    
    convenience init (book: Book, title: String, text: String, page: Int32 = 0, context: NSManagedObjectContext){
        let entity = NSEntityDescription.entity(forEntityName: Annotation.entity().name!, in: context)!
        
        self.init(entity: entity, insertInto: context)
        
        self.book = book
        self.creationDate = NSDate()
        self.modifiedDate = NSDate()
        self.title = title
        self.text = text
        
        saveContext(context: context)
    }
    
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

    class func fetchController( book: Book, context: NSManagedObjectContext) -> NSFetchedResultsController<Annotation>{
        let frc = NSFetchedResultsController(fetchRequest: Annotation.fetchRequest(book: book),
                                             managedObjectContext: context,
                                             sectionNameKeyPath: nil,
                                             cacheName: nil)
        
        do {
            try frc.performFetch()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        return frc
    }
    
    class func fetchRequest(book: Book) -> NSFetchRequest<Annotation>{
        let fr = NSFetchRequest<Annotation>(entityName: Annotation.entity().name!)
        
        // Set the batch size to a suitable number.
        fr.fetchBatchSize = 20
        
        let bookPredicate = NSPredicate(format: "(book == %@)",book)

        let predicate = NSCompoundPredicate(orPredicateWithSubpredicates: [bookPredicate])
        fr.predicate = predicate
        
        fr.sortDescriptors = [NSSortDescriptor(key: "modifiedDate", ascending: false),
                              NSSortDescriptor(key: "title", ascending: true)]
        
        return fr
    }
}
