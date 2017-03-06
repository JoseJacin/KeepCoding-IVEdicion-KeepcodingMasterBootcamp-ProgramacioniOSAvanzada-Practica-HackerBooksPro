//
//  DateFormatter.swift
//  HackerBooksPro
//
//  Created by Jose Sanchez Rodriguez on 03/03/2017.
//  Copyright © 2017 Jose Sanchez Rodriguez. All rights reserved.
//

import Foundation

func formatDate(_ date: Date) -> String {
    return dateFormatter.string(from: date)
}
    
fileprivate let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .short
    return formatter
}()
