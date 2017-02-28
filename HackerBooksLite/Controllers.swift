//
//  Controllers.swift
//  HackerBooksLite
//
//  Created by Fernando Rodríguez Romero on 8/17/16.
//  Copyright © 2016 KeepCoding. All rights reserved.
//

import UIKit

extension UIViewController{
    
    func wrappedInNavigationController()->UINavigationController{
        return UINavigationController(rootViewController: self)
    }
}
