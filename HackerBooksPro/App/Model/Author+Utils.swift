//
//  Author+Utils.swift
//  HackerBooksPro
//
//  Created by Jose Sanchez Rodriguez on 25/02/2017.
//  Copyright © 2017 Jose Sanchez Rodriguez. All rights reserved.
//

import Foundation
import CoreData

extension Author {
    
    convenience init(name: String, context: NSManagedObjectContext){
        let entity = NSEntityDescription.entity(forEntityName: Author.entity().name!, in: context)!
        
        let authorName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        
        self.init(entity: entity, insertInto: context)
        self.name = authorName
        
        saveContext(context: context)
    }
    
    class func get(name: String, context: NSManagedObjectContext?) -> Author{
        let authorName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let fr = NSFetchRequest<Author>(entityName: Author.entity().name!)
        fr.fetchLimit = 1
        fr.fetchBatchSize = 1
        fr.predicate = NSPredicate(format: "name == %@", name)
        
        do{
            let result = try context?.fetch(fr)
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

    class func fromStringToSet(s : String, context: NSManagedObjectContext) -> Set<Author>{
        var ret = Set<Author>()
        let arr = s.characters.split{$0 == ","}.map(String.init)
        for each in arr{
            ret.insert(Author.init(name: each, context: context))
        }
        return ret
    }
}
