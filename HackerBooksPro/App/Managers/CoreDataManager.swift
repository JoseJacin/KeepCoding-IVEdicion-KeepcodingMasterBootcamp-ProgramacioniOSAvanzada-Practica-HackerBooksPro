//
//  CoreDataManager.swift
//  HackerBooksPro
//
//  Created by Jose Sanchez Rodriguez on 25/02/2017.
//  Copyright © 2017 Jose Sanchez Rodriguez. All rights reserved.
//

import CoreData

public func persistentContainer(dbName: String, onError: ((NSError)->Void)? = nil) -> NSPersistentContainer {
    let container = NSPersistentContainer(name: dbName)
    
    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
        if let error = error as NSError?, let onError = onError {
            onError(error)
        }
    })
    return container
}

public func saveContext(context: NSManagedObjectContext, process: Bool = false) {
    if context.hasChanges {
        do {
            try context.save()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }    
    if(process){
        context.processPendingChanges()
    }
}

