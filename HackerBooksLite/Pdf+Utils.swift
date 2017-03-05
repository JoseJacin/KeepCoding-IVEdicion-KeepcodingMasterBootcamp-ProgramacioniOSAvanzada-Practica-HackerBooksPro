//
//  Pdf.swift
//  HackerBooksLite
//
//  Created by Jose Sanchez Rodriguez on 3/3/17.
//  Copyright © 2017 KeepCoding. All rights reserved.
//

import Foundation
import CoreData

extension Pdf{
    // MARK: - Initiators
    // Convenience Initialicer
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
    
    //MARK: - Functions
    // Function that returns a PDF according to the book
    class func get(book: Book, binary: NSData? = nil, context: NSManagedObjectContext?) -> Pdf{
        let fetchRequest = NSFetchRequest<Pdf>(entityName: Pdf.entity().name!)
        fetchRequest.fetchLimit = 1
        fetchRequest.fetchBatchSize = 1
        fetchRequest.predicate = NSPredicate(format: "book == %@", book)
        do{
            let result = try context?.fetch(fetchRequest)
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
