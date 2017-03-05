//
//  Library_old.swift
//  HackerBooksLite
//
//  Created by Fernando Rodríguez Romero on 8/14/16.
//  Copyright © 2016 KeepCoding. All rights reserved.
//

import Foundation

//MARK: - MultiDict
typealias Books = MultiDictionary<Tag_old, Book_old>

//MARK: - Library_old
class Library_old {
    
    var _books : Books
    
    var _bookObserver : NSObjectProtocol?
    
    //MARK: - Lifecycle
    init(books : [Book_old]){
        
        _books = Books()
        
        loadBooks(bookList: books)
        
        setupNotifications()
        
    }
    
    deinit {
        tearDownNotifications()
    }
    
    private
    func loadBooks(bookList: [Book_old]){
        
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
        
        let tag = Tag_old(name: name)
        
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
    func books(forTagName name: TagName) -> [Book_old]?{
        
        guard let books = _books[Tag_old(name:name)] else {
            return nil
        }
        
        if books.count == 0 {
            return nil
        }else{
            return books.sorted()
        }
        
    }
    
    
    // Book_old at the index position within the Tag. If either the index
    // or tag doesn't exist, should return nil
    func book(forTagName name: TagName, at:Int)-> Book_old?{
        
        guard let books = _books[Tag_old(name: name)] else{
            return nil
        }
        
        guard !(books.count > 0 && at > books.count) else{
            return nil
        }
        
        return books.sorted()[at]
        
    }
    
    // Sorted Tags
    var tags : [Tag_old]{
        get{
            return _books.keys.sorted()
        }
    }
    
}

//MARK: - Notifications
extension Library_old{
    
    // We observe the BookDidChange notification that
    // tells me that the favorite switch has been flipped
    func setupNotifications(){
        let nc = NotificationCenter.default
        _bookObserver = nc.addObserver(forName: BookDidChange, object: nil, queue: nil){
            (n: Notification) in
            
            // Extract the book
            let book = n.userInfo![BookKey] as! Book_old
            
            
            // Create a Favorite tag
            let fav = Tag_old.favoriteTag()
            
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





