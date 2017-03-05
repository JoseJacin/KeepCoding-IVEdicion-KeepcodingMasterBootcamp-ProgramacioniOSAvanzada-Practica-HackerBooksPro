//
//  cover+Utils.swift
//  HackerBooksLite
//
//  Created by Jose Sanchez Rodriguez on 3/3/17.
//  Copyright © 2017 KeepCoding. All rights reserved.
//

import Foundation
import CoreData

extension Cover{
    // MARK: - Initiators
    // Convenience Initialicer
    convenience init(book: Book, binary: NSData?, context: NSManagedObjectContext){
        
        let entity = NSEntityDescription.entity(forEntityName: Cover.entity().name!, in: context)!
        
        if(binary == nil){
            self.init(entity: entity, insertInto: context)
        }else{
            self.init(entity: entity, insertInto: context)
            self.book = book
            self.binary = binary
            saveContext(context: context)
        }
        
    }
    
    //MARK: - Functions
    // Function that returns a cover according to the book
    class func get(book: Book, binary: NSData? = nil, context: NSManagedObjectContext?) -> Cover{
        let fetchRequest = NSFetchRequest<Cover>(entityName: Cover.entity().name!)
        fetchRequest.fetchLimit = 1
        fetchRequest.fetchBatchSize = 1
        fetchRequest.predicate = NSPredicate(format: "book == %@", book)
        do{
            let result = try context?.fetch(fetchRequest)
            guard let resp = result else{
                return Cover.init(book: book, binary: binary, context: context!)
            }
            if(resp.count > 0){
                return resp.first!
            }else{
                return Cover.init(book: book, binary: binary, context: context!)
            }
        } catch{
            return Cover.init(book: book, binary: binary, context: context!)
        }
    }
    
}

