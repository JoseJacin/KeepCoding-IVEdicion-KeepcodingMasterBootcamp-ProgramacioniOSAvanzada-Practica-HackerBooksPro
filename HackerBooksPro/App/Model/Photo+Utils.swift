//
//  Photo+Utils.swift
//  HackerBooksPro
//
//  Created by Jose Sanchez Rodriguez on 02/03/2017.
//  Copyright © 2017 Jose Sanchez Rodriguez. All rights reserved.
//

import Foundation
import CoreData

extension Photo{
    
    convenience init(annotation: Annotation, binary: NSData?, context: NSManagedObjectContext){
        let entity = NSEntityDescription.entity(forEntityName: Photo.entity().name!, in: context)!
        
        if(binary == nil){
            self.init(entity: entity, insertInto: context)
        }else{
            self.init(entity: entity, insertInto: context)
            self.annotation = annotation
            self.binary = binary
            saveContext(context: context)
        }
    }
    
    class func get(annotation: Annotation, binary: NSData? = nil, context: NSManagedObjectContext?) -> Photo{
        let fr = NSFetchRequest<Photo>(entityName: Photo.entity().name!)
        fr.fetchLimit = 1
        fr.fetchBatchSize = 1
        fr.predicate = NSPredicate(format: "annotation == %@", annotation)
        
        do{
            let result = try context?.fetch(fr)
            guard let resp = result else{
                return Photo.init(annotation: annotation, binary: binary, context: context!)
            }
            if(resp.count > 0){
                return resp.first!
            }else{
                return Photo.init(annotation: annotation, binary: binary, context: context!)
            }
        } catch{
            return Photo.init(annotation: annotation, binary: binary, context: context!)
        }
    }
}
