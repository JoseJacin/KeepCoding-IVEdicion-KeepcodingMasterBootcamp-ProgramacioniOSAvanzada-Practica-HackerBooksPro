//
//  BookCollectionViewCell.swift
//  HackerBooksPro
//
//  Created by Jose Sanchez Rodriguez on 25/02/2017.
//  Copyright © 2017 Jose Sanchez Rodriguez. All rights reserved.
//

import UIKit
import CoreData

class BookCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var bookImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorsLabel: UILabel!
    @IBOutlet weak var tagsLabel: UILabel!
    
    var context: NSManagedObjectContext? = nil
    
    var _booktag: BookTag? = nil
    var book: BookTag{
        get{
            return _booktag!
        }
        set{
            _booktag = newValue
            titleLabel.text = newValue.book?.title
            authorsLabel.text = newValue.book?.authorsString
            tagsLabel.text = newValue.book?.tagsString()
            
            bookImage.image = UIImage(named: constants.defaultBookCover)
                
            if var book = newValue.book{
                if let cover = newValue.book?.cover {
                    loadCover(cover: cover.binary as! Data)
                }else{
                    DataInteractor(manager: DownloadAsyncGCD()).cover(book: book, completion: { (data: Data) in
                        book = Book.get(title: book.title!, context: self.context!)
                        let cover = Cover.get(book: book, binary: data as NSData, context: self.context!)
                        self.loadCover(cover: cover.binary as! Data)
                    })
                }
            }
        }
    }
    
    func loadCover(cover: Data){
        self.bookImage.image = UIImage(data: cover)
    }
}
