//
//  Pdf+Utils.swift
//  HackerBooksPro
//
//  Created by Jose Sanchez Rodriguez on 02/03/2017.
//  Copyright © 2017 Jose Sanchez Rodriguez. All rights reserved.
//

import Foundation
import CoreData

extension Pdf{
    
    convenience init(book: Book, binary: NSData?, context: NSManagedObjectContext){
        let entity = NSEntityDescription.entity(forEntityName: Pdf.entity().name!, in: context)!
        
        if(binary == nil){
            self.init(entity: entity, insertInto: context)
        }else{
            self.init(entity: entity, insertInto: context)
            self.book = book
            self.binary = binary
            saveContext(context: context)
        }
    }
    
    class func get(book: Book, binary: NSData? = nil, context: NSManagedObjectContext?) -> Pdf{
        let fr = NSFetchRequest<Pdf>(entityName: Pdf.entity().name!)
        fr.fetchLimit = 1
        fr.fetchBatchSize = 1
        fr.predicate = NSPredicate(format: "book == %@", book)
        do{
            let result = try context?.fetch(fr)
            guard let resp = result else{
                return Pdf.init(book: book, binary: binary, context: context!)
            }
            if(resp.count > 0){
                return resp.first!
            }else{
                return Pdf.init(book: book, binary: binary, context: context!)
            }
        } catch{
            return Pdf.init(book: book, binary: binary, context: context!)
        }
    }
}
