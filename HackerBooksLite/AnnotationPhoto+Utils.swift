//
//  AnnotationPhoto+Utils.swift
//  HackerBooksLite
//
//  Created by Jose Sanchez Rodriguez on 3/3/17.
//  Copyright © 2017 KeepCoding. All rights reserved.
//

import Foundation
import CoreData

extension AnnotationPhoto{
    // MARK: - Initiators
    // Convenience Initialicer
    convenience init(annotation: Annotation, binary: NSData?, context: NSManagedObjectContext){
        let entity = NSEntityDescription.entity(forEntityName: AnnotationPhoto.entity().name!, in: context)!
        
        if(binary == nil){
            self.init(entity: entity, insertInto: context)
        }else{
            self.init(entity: entity, insertInto: context)
            self.annotation = annotation
            self.binary = binary
            saveContext(context: context)
        }
        
    }
    
    //MARK: - Functions
    // Function that returns a annotation Photo according to the annotation
    class func get(annotation: Annotation, binary: NSData? = nil, context: NSManagedObjectContext?) -> AnnotationPhoto{
        let fetchRequest = NSFetchRequest<AnnotationPhoto>(entityName: AnnotationPhoto.entity().name!)
        fetchRequest.fetchLimit = 1
        fetchRequest.fetchBatchSize = 1
        fetchRequest.predicate = NSPredicate(format: "annotation == %@", annotation)
        do{
            let result = try context?.fetch(fetchRequest)
            guard let resp = result else{
                return AnnotationPhoto.init(annotation: annotation, binary: binary, context: context!)
            }
            if(resp.count > 0){
                return resp.first!
            }else{
                return AnnotationPhoto.init(annotation: annotation, binary: binary, context: context!)
            }
        } catch{
            return AnnotationPhoto.init(annotation: annotation, binary: binary, context: context!)
        }
    }
    
}

