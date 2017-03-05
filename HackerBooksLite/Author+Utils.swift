//
//  Author.swift
//  HackerBooksLite
//
//  Created by Jose Sanchez Rodriguez on 3/3/17.
//  Copyright © 2017 KeepCoding. All rights reserved.
//

import Foundation
import CoreData

extension Author {
    // MARK: - Initiators
    // Convenience Initialicer
    convenience init(name: String, context: NSManagedObjectContext){
        let entity = NSEntityDescription.entity(forEntityName: Author.entity().name!, in: context)!
        
        let authorName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        
        self.init(entity: entity, insertInto: context)
        self.name = authorName
        
        saveContext(context: context)
    }
    
    //MARK: - Functions
    // Function that returns a Author by name
    class func get(name: String, context: NSManagedObjectContext?) -> Author{
        
        let authorName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let fetchRequest = NSFetchRequest<Author>(entityName: Author.entity().name!)
        fetchRequest.fetchLimit = 1
        fetchRequest.fetchBatchSize = 1
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        
        do{
            let result = try context?.fetch(fetchRequest)
            guard let resp = result else{
                return Author.init(name: authorName, context: context!)
            }
            if(resp.count > 0){
                return resp.first!
            }else{
                return Author.init(name: authorName, context: context!)
            }
        } catch{
            return Author.init(name: authorName, context: context!)
        }
    }
    
    // Function that split the authors by comma ','
    class func fromStringToSet(s : String, context: NSManagedObjectContext) -> Set<Author>{
        var ret = Set<Author>()
        let arr = parseCommaSeparated(string: s)
        for each in arr{
            ret.insert(Author.init(name: each, context: context))
        }
        return ret
    }
    
}

