//
//  BookTag+Utils.swift
//  HackerBooksPro
//
//  Created by Jose Sanchez Rodriguez on 26/02/2017.
//  Copyright © 2017 Jose Sanchez Rodriguez. All rights reserved.
//

import Foundation
import CoreData

extension BookTag{
    
    convenience init(book: Book, tag: Tag, context: NSManagedObjectContext){
        let entity = NSEntityDescription.entity(forEntityName: BookTag.entity().name!, in: context)!
        
        self.init(entity: entity, insertInto: context)
        self.book = book
        self.tag = tag
        
    }
    
    class func get(book: Book, tag: Tag, context: NSManagedObjectContext?) -> BookTag{
        let fr = NSFetchRequest<BookTag>(entityName: BookTag.entity().name!)
        fr.fetchLimit = 1
        fr.fetchBatchSize = 1
        fr.predicate = NSPredicate(format: "(book == %@) and (tag = %@)", book, tag)
        do{
            let result = try context?.fetch(fr)
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
        
    class func fetchController(context: NSManagedObjectContext, text: String) -> NSFetchedResultsController<BookTag>{
        let frc = NSFetchedResultsController(fetchRequest: BookTag.fetchRequest(text: text),
                                            managedObjectContext: context,
                                            sectionNameKeyPath: "tag.proxyForSorting",
                                            cacheName: "BookTag")
        
        do {
            try frc.performFetch()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        return frc
    }

    class func fetchRequest(text: String) -> NSFetchRequest<BookTag>{
        let fr = NSFetchRequest<BookTag>(entityName: BookTag.entity().name!)
        
        // Set the batch size to a suitable number.
        fr.fetchBatchSize = 20
        
        if(text != ""){
            let t = text.lowercased()
            
            let tagPredicate = NSPredicate(format: "tag.name contains [cd] %@",t)
            let bookPredicate = NSPredicate(format: "book.title contains [cd] %@",t)
            let authorPredicate = NSPredicate(format: "book.authors.name contains [cd] %@",t)
                
            let predicate = NSCompoundPredicate(orPredicateWithSubpredicates: [tagPredicate,bookPredicate,authorPredicate])
            fr.predicate = predicate
        }
        
        fr.sortDescriptors = [NSSortDescriptor(key: "tag.proxyForSorting", ascending: true),
                              NSSortDescriptor(key: "book.title", ascending: true)]
        
        return fr
    }
}
