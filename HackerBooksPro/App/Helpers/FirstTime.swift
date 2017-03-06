//
//  FirstTime.swift
//  HackerBooksPro
//
//  Created by Jose Sanchez Rodriguez on 26/02/2017.
//  Copyright © 2017 Jose Sanchez Rodriguez. All rights reserved.
//

import Foundation

//Is first time launched?
public func isFirstTime() -> Bool {
    let userDef = UserDefaults.standard
    let firstTime = !userDef.bool(forKey: constants.isFirstTimeLaunched)
    
    return firstTime
}

//Set is not first time
public func setAppLaunched() {
    let userDef = UserDefaults.standard
    userDef.set(true, forKey: constants.isFirstTimeLaunched)
}
