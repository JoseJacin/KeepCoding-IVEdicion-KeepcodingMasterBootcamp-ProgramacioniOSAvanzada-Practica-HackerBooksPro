//
//  DataInteractor.swift
//  HackerBooksPro
//
//  Created by Jose Sanchez Rodriguez on 25/02/2017.
//  Copyright © 2017 Jose Sanchez Rodriguez. All rights reserved.
//

import Foundation
import UIKit

public class DataInteractor: Interactor {
    
    public func pdf(book: Book, completion: @escaping (Data) -> Void) {
        manager.downloadData(urlString: book.pdfUrl!, completion: { (data: Data) in
            assert(Thread.current == Thread.main)
            completion(data)
        }, onError: nil)
    }
    
    public func cover(book: Book, completion: @escaping (Data) -> Void) {
        manager.downloadData(urlString: book.coverUrl!, completion: { (data: Data) in
            assert(Thread.current == Thread.main)
            completion(data)
        }, onError: nil)
    }
}
