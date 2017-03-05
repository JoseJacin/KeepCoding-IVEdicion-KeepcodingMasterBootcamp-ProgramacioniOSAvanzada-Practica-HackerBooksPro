//
//  FirstTimeLaunched.swift
//  HackerBooksLite
//
//  Created by Jose Sanchez Rodriguez on 3/3/17.
//  Copyright © 2017 KeepCoding. All rights reserved.
//

import Foundation

//MARK: - First time launched
// Returns if the application is launched for the first time
public func isFirstTimeLaunched() -> Bool {
    let userDef = UserDefaults.standard
    let firstTimeLaunched = !userDef.bool(forKey: constants.isFirstTimeLaunched)
    
    return firstTimeLaunched
}

// Set the application has already been launched before
public func setLaunched() {
    let userDef = UserDefaults.standard
    userDef.set(true, forKey: constants.isFirstTimeLaunched)
}
