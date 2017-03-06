//
//  Thumbnail+Utils.swift
//  HackerBooksPro
//
//  Created by Jose Sanchez Rodriguez on 02/03/2017.
//  Copyright © 2017 Jose Sanchez Rodriguez. All rights reserved.
//

import Foundation
import CoreData

extension Cover{
    
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
    
    class func get(book: Book, binary: NSData? = nil, context: NSManagedObjectContext?) -> Cover{
        let fr = NSFetchRequest<Cover>(entityName: Cover.entity().name!)
        fr.fetchLimit = 1
        fr.fetchBatchSize = 1
        fr.predicate = NSPredicate(format: "book == %@", book)
        do{
            let result = try context?.fetch(fr)
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
