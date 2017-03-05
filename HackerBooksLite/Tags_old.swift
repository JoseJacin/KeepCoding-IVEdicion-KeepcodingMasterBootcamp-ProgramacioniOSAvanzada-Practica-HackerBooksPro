//
//  Tags.swift
//  HackerBooksLite
//
//  Created by Fernando Rodríguez Romero on 8/14/16.
//  Copyright © 2016 KeepCoding. All rights reserved.
//

import Foundation

typealias Tags = Set<Tag_old>
typealias TagName = String

struct TagConstants{
    static let favoriteTag = "Favorite"
}

struct Tag_old{
    
    let _name : TagName
    
    init(name: TagName) {
        _name = name.capitalized
    }
    
    static func favoriteTag()->Tag_old{
        return self.init(name: TagConstants.favoriteTag)
    }
    
    func isFavorite()->Bool{
        return _name == TagConstants.favoriteTag
    }
}

//MARK: - Hashable
// Since tags will go into a MultiDictionary, they must be hashable
extension Tag_old: Hashable{
    public var hashValue: Int {
        return _name.hashValue
    }
}

//MARK: - Equatable
// To be hashable, you must be equatable
// As of swift 3.0, operators can be declared in
// extension
extension Tag_old : Equatable{
    static func ==(lhs: Tag_old, rhs: Tag_old) -> Bool{
        return (lhs._name == rhs._name)
    }
}


//MARK: - Comparable
extension Tag_old: Comparable{
    static func <(lhs: Tag_old, rhs: Tag_old) -> Bool{
        
        if lhs.isFavorite(){
            return true
        }
        else if rhs.isFavorite(){
            return false
        }else{
            return lhs._name < rhs._name
        }
    }
    
}











