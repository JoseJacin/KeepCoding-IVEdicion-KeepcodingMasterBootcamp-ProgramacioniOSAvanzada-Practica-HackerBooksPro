//
//  Tags.swift
//  HackerBooksLite
//
//  Created by Fernando Rodríguez Romero on 8/14/16.
//  Copyright © 2016 KeepCoding. All rights reserved.
//

import Foundation

typealias Tags = Set<Tag>
typealias TagName = String

struct TagConstants{
    static let favoriteTag = "Favorite"
}

struct Tag{
    
    let _name : TagName
    
    init(name: TagName) {
        _name = name.capitalized
    }
    
    static func favoriteTag()->Tag{
        return self.init(name: TagConstants.favoriteTag)
    }
    
    func isFavorite()->Bool{
        return _name == TagConstants.favoriteTag
    }
}

//MARK: - Hashable
// Since tags will go into a MultiDictionary, they must be hashable
extension Tag: Hashable{
    public var hashValue: Int {
        return _name.hashValue
    }
}

//MARK: - Equatable
// To be hashable, you must be equatable
// As of swift 3.0, operators can be declared in
// extension
extension Tag : Equatable{
    static func ==(lhs: Tag, rhs: Tag) -> Bool{
        return (lhs._name == rhs._name)
    }
}


//MARK: - Comparable
extension Tag: Comparable{
    static func <(lhs: Tag, rhs: Tag) -> Bool{
        
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











