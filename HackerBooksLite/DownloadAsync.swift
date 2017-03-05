//
//  DownloadAsync.swift
//  HackerBooksLite
//
//  Created by Jose Sanchez Rodriguez on 4/3/17.
//  Copyright © 2017 KeepCoding. All rights reserved.
//

import Foundation
import CoreData

public typealias ErrorClosure = (Error) -> Void

public protocol DownloadAsync {
    func downloadJson(urlString: String, context: NSManagedObjectContext, completion: @escaping (Void) -> Void, onError:  ErrorClosure?)
    func downloadData(urlString: String, completion: @escaping (Data) -> Void, onError:  ErrorClosure?)
    
}

