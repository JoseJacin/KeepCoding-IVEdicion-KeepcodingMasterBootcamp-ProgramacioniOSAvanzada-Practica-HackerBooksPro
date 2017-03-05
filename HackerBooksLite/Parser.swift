//
//  Parser.swift
//  HackerBooksLite
//
//  Created by Jose Sanchez Rodriguez on 4/3/17.
//  Copyright © 2017 KeepCoding. All rights reserved.
//

import Foundation

//MARK: - Parsing
public func parseCommaSeparated (string s: String) -> [String] {
    return s.components(separatedBy: ",").map({ $0.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)}).filter({ $0.characters.count > 0})
}
