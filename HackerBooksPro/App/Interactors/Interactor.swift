//
//  Interactor.swift
//  HackerBooksPro
//
//  Created by Jose Sanchez Rodriguez on 25/02/2017.
//  Copyright © 2017 Jose Sanchez Rodriguez. All rights reserved.
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
    
