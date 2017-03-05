//
//  Interactor.swift
//  HackerBooksLite
//
//  Created by Jose Sanchez Rodriguez on 4/3/17.
//  Copyright © 2017 KeepCoding. All rights reserved.
//

import Foundation

public class Interactor{
    let manager: DownloadAsync
    
    public init(manager: DownloadAsync){
        self.manager = manager
    }
    
    public convenience init(){
        self.init(manager: DownloadAsyncGCD())
    }
    
}
