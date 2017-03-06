//
//  JSONInteractor.swift
//  HackerBooksPro
//
//  Created by Jose Sanchez Rodriguez on 25/02/2017.
//  Copyright © 2017 Jose Sanchez Rodriguez. All rights reserved.
//

import Foundation
import UIKit
import CoreData

public class JSONInteractor: Interactor {
    
    public func execute(urlString: String, context: NSManagedObjectContext, completion: @escaping (Void) -> Void) {
        manager.downloadJson(urlString: urlString, context: context, completion: { (Void) in
            completion()
        }, onError: nil)
    }
}
