//
//  Books.swift
//  HackerBooksLite
//
//  Created by Fernando Rodríguez Romero on 8/11/16.
//  Copyright © 2016 KeepCoding. All rights reserved.
//

import UIKit

// Use typealias early. It provides extra information to the reader.
// If you later need to expand one of them into fullblown
// class or structure, it won't break your code!
typealias Author = String
typealias Authors = [Author]
typealias Title = String
typealias PDF = AsyncData
typealias Image = AsyncData


class Book{
    let _authors : Authors
    let _title   : Title
    var _tags    : Tags
    let _pdf     : PDF
    let _image   : Image

    weak var delegate    : BookDelegate?
    
    var tags : Tags{
        return _tags
    }
    
    var title : Title{
        return _title
    }

    
    init(title: Title, authors: Authors,
         tags: Tags, pdf: PDF, image: Image) {
        
        (_title, _authors, _tags, _pdf, _image) = (title, authors, tags, pdf, image)
        
        // Set delegate
        _image.delegate = self
        _pdf.delegate = self
        
        
    }
    
    func formattedListOfAuthors() -> String{
        
        return _authors.sorted().joined(separator: ", ").capitalized
        
    }
    
    func formattedListOfTags() -> String{
        return _tags.sorted().map{$0._name}.joined(separator: ", ").capitalized
    }
    
    
}


//MARK: - Favorites
extension Book{
    
    private func hasFavoriteTag()->Bool{
        return _tags.contains(Tag.favoriteTag())
    }
    
    
    private func addFavoriteTag(){
        _tags.insert(Tag.favoriteTag())
    }
    
    private func removeFavoriteTag() {
        _tags.remove(Tag.favoriteTag())
    }
    
    
    var isFavorite : Bool{
        
        get{
            return hasFavoriteTag()
        }
        
        set{
            if newValue == true{
                addFavoriteTag()
                sendNotification(name: BookDidChange)
            }else{
                removeFavoriteTag()
                sendNotification(name: BookDidChange)
            }
        }
        
    }
    
}
//MARK: - Protocols
extension Book: Hashable{
    
    var proxyForHashing : String{
        get{
            return "\(_title)\(_authors)"
        }
    }
    var hashValue: Int {
        return proxyForHashing.hashValue
    }
}

extension Book : Equatable{
    var proxyForComparison : String{
        // Favorite always first
        return "\(isFavorite ? "A" : "Z")\(_title)\(formattedListOfAuthors())"
    }
    
    static func ==(lhs: Book, rhs: Book) -> Bool{
        return lhs.proxyForComparison == rhs.proxyForComparison
    }
}

extension Book : Comparable{
    static func <(lhs: Book, rhs: Book) -> Bool{
        return lhs.proxyForComparison < rhs.proxyForComparison
    }
}


//MARK: - Communication - delegate
protocol BookDelegate: class{
    func bookDidChange(sender:Book)
    func bookCoverImageDidDownload(sender: Book)
    func bookPDFDidDownload(sender: Book)
}

// Default implementation of delegate methods
extension BookDelegate{
    
    func bookDidChange(sender:Book){}
    func bookCoverImageDidDownload(sender: Book){}
    func bookPDFDidDownload(sender: Book){}
}

let BookDidChange = Notification.Name(rawValue: "io.keepCoding.BookDidChange")
let BookKey = "io.keepCoding.BookDidChange.BookKey"

let BookCoverImageDidDownload = Notification.Name(rawValue: "io.keepCoding.BookCoverImageDidDownload")
let BookPDFDidDownload = Notification.Name(rawValue: "io.keepCoding.BookPDFDidDownload")

extension Book{
    
    func sendNotification(name: Notification.Name){
        
        let n = Notification(name: name, object: self, userInfo: [BookKey:self])
        let nc = NotificationCenter.default
        nc.post(n)
        
    }
}


//MARK: - AsyncDataDelegate
extension Book: AsyncDataDelegate{
    
    func asyncData(_ sender: AsyncData, didEndLoadingFrom url: URL) {
        
        let notificationName : Notification.Name
        
        
        switch sender {
        case _image:
            notificationName = BookCoverImageDidDownload
            delegate?.bookCoverImageDidDownload(sender: self)
            
        case _pdf:
            notificationName = BookPDFDidDownload
            delegate?.bookPDFDidDownload(sender: self)
            
        default:
            fatalError("Should never get here")
        }
        
        
        sendNotification(name: notificationName)
    }
    
    func asyncData(_ sender: AsyncData, shouldStartLoadingFrom url: URL) -> Bool {
        return true
    }
    
    func asyncData(_ sender: AsyncData, willStartLoadingFrom url: URL) {
        print("Starting with \(url)")
    }
    
    func asyncData(_ sender: AsyncData, didFailLoadingFrom url: URL, error: NSError){
        print("Error loading \(url).\n \(error)")
    }
}





