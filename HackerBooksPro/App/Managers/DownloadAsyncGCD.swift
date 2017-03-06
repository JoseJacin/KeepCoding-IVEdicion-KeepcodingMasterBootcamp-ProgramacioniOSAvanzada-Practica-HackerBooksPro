//
//  DownloadAsyncGCD.swift
//  HackerBooksPro
//
//  Created by Jose Sanchez Rodriguez on 25/02/2017.
//  Copyright © 2017 Jose Sanchez Rodriguez. All rights reserved.
//

import Foundation
import UIKit
import CoreData

public class DownloadAsyncGCD: DownloadAsync {
    var backgroundUpdateTask: UIBackgroundTaskIdentifier!
    
    func beginBackgroundUpdateTask() {
        self.backgroundUpdateTask = UIApplication.shared.beginBackgroundTask(expirationHandler: {
            self.endBackgroundUpdateTask()
        })
    }
    
    func endBackgroundUpdateTask() {
        UIApplication.shared.endBackgroundTask(self.backgroundUpdateTask)
        self.backgroundUpdateTask = UIBackgroundTaskInvalid
    }
   
    public func downloadJson(urlString: String, context: NSManagedObjectContext, completion: @escaping (Void) -> Void, onError:  ErrorClosure?){
        DispatchQueue.global().async {
            do{
                self.beginBackgroundUpdateTask()

                let json_data = try getFileFrom(urlString: urlString)
                let json = try jsonLoadFromData(dataInput: json_data)
                try decodeBooks(books: json, context: context)
                                
                saveContext(context: context, process: true)
                
                DispatchQueue.main.async {
                    completion()
                }

                self.endBackgroundUpdateTask()
                
            } catch {
                if let errorClosure = onError {
                    errorClosure(error)
                }
            }
        }
    }
    
    public func downloadData(urlString: String, completion: @escaping (Data) -> Void, onError:  ErrorClosure?){
        DispatchQueue.global().async {
            self.beginBackgroundUpdateTask() 

            var data = Data()
            if let url = URL.init(string: urlString){
                do{
                    data = try Data.init(contentsOf: url)
                }catch{
                    data = Data()
                }
            }
                
            DispatchQueue.main.async {
                completion(data)
            }

            self.endBackgroundUpdateTask()
        }
    }
}
