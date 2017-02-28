//
//  Library.swift
//  HackerBooksLite
//
//  Created by Fernando Rodríguez Romero on 8/14/16.
//  Copyright © 2016 KeepCoding. All rights reserved.
//

import Foundation

//MARK: - MultiDict
typealias Books = MultiDictionary<Tag, Book>

//MARK: - Library
class Library {
    
    var _books : Books
    
    var _bookObserver : NSObjectProtocol?
    
    //MARK: - Lifecycle
    init(books : [Book]){
        
        _books = Books()
        
        loadBooks(bookList: books)
        
        setupNotifications()
        
    }
    
    deinit {
        tearDownNotifications()
    }
    
    private
    func loadBooks(bookList: [Book]){
        
        for book in bookList{
            for tag in book.tags{
                _books.insert(value: book, forKey: tag)
            }
        }
    }
    
    //MARK: - Accessors
    var bookCount: Int{
        get{
            return _books.countUnique
        }
    }
    
    // if the Tag is not present, returns zero
    func bookCount(forTagName name: TagName) -> Int{
        
        let tag = Tag(name: name)
        
        if let bucket = _books[tag] {
            return bucket.count
        }else {
            return 0
        }
        
    }
    
    
    // sorted array of books for a given tag. A book can
    // be in several tags.
    // If the tag doesn't exists or there are no book sin it
    // returns an empty optional
    func books(forTagName name: TagName) -> [Book]?{
        
        guard let books = _books[Tag(name:name)] else {
            return nil
        }
        
        if books.count == 0 {
            return nil
        }else{
            return books.sorted()
        }
        
    }
    
    
    // Book at the index position within the Tag. If either the index
    // or tag doesn't exist, should return nil
    func book(forTagName name: TagName, at:Int)-> Book?{
        
        guard let books = _books[Tag(name: name)] else{
            return nil
        }
        
        guard !(books.count > 0 && at > books.count) else{
            return nil
        }
        
        return books.sorted()[at]
        
    }
    
    // Sorted Tags
    var tags : [Tag]{
        get{
            return _books.keys.sorted()
        }
    }
    
}

//MARK: - Notifications
extension Library{
    
    // We observe the BookDidChange notification that
    // tells me that the favorite switch has been flipped
    func setupNotifications(){
        let nc = NotificationCenter.default
        _bookObserver = nc.addObserver(forName: BookDidChange, object: nil, queue: nil){
            (n: Notification) in
            
            // Extract the book
            let book = n.userInfo![BookKey] as! Book
            
            
            // Create a Favorite tag
            let fav = Tag.favoriteTag()
            
            // if it's favorite, add it to the Favorite bucket,
            // otherwise remove it from there

            if book.isFavorite{
                // Add it
                self._books.insert(value: book, forKey: fav)
            }else{
                // remove it
                self._books.remove(value: book, fromKey: fav)

            }
            
        }
    }
    
    func tearDownNotifications(){
        guard let observer = _bookObserver else{
            return
        }
        let nc = NotificationCenter.default
        nc.removeObserver(observer)
    }
}





