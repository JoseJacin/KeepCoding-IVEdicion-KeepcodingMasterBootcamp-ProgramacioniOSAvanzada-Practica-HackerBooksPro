//
//  JSONInteractor.swift
//  HackerBooksLite
//
//  Created by Jose Sanchez Rodriguez on 4/3/17.
//  Copyright © 2017 KeepCoding. All rights reserved.
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
