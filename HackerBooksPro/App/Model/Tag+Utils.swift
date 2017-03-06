//
//  Tag.swift
//  HackerBooksLite
//
//  Created by Jose Sanchez Rodriguez on 3/3/17.
//  Copyright © 2017 KeepCoding. All rights reserved.
//

import Foundation
import CoreData

extension Tag {
    // MARK: - Initiators
    // Convenience Initialicer
    convenience init(name: String, context: NSManagedObjectContext){
        
        let entity = NSEntityDescription.entity(forEntityName: Tag.entity().name!, in: context)!
        
        let tagName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        
        self.init(entity: entity, insertInto: context)
        self.name = tagName
        
        switch tagName
        {
        case constants.favoritesBooks:
            self.proxyForSorting = "__" + tagName
        case constants.finishedBooks:
            self.proxyForSorting = "___" + tagName
        case constants.lastReadingBook:
            self.proxyForSorting = "____" + tagName
        default:
            self.proxyForSorting = tagName
        }
        
        saveContext(context: context)
    }
    
    //MARK: - Functions
    // Function that returns a Tag by name
    class func get(name: String, context: NSManagedObjectContext?) -> Tag{
        
        let fetchRequest = NSFetchRequest<Tag>(entityName: Tag.entity().name!)
        fetchRequest.fetchLimit = 1
        fetchRequest.fetchBatchSize = 1
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        
        do{
            let result = try context?.fetch(fetchRequest)
            guard let resp = result else{
                return Tag.init(name: name, context: context!)
            }
            if(resp.count > 0){
                return resp.first!
            }else{
                return Tag.init(name: name, context: context!)
            }
        } catch{
            return Tag.init(name: name, context: context!)
        }
        
    }
    
}

