//
//  BookTableViewCell.swift
//  HackerBooksLite
//
//  Created by Fernando Rodríguez Romero on 8/22/16.
//  Copyright © 2016 KeepCoding. All rights reserved.
//

import UIKit

class BookTableViewCell: UITableViewCell {

    //MARK: - Static vars
    static let cellID = "BookTableViewCellId"
    static let cellHeight : CGFloat = 66.0
    
    
    //MARK: - private interface
    private
    var _book : Book?
    
    private
    let _nc = NotificationCenter.default
    private
    var _bookObserver : NSObjectProtocol?
    
    //MARK: - Outlets
    @IBOutlet weak var coverView: UIImageView!
    @IBOutlet weak var titleView: UILabel!
    @IBOutlet weak var authorsView: UILabel!
    @IBOutlet weak var tagsView: UILabel!
    
    //MARK: - Bending the MVC
    // The view will directly observe the model
    // This is OK, when the view is highly specific as
    // in this case
    func startObserving(book: Book){
        _book = book
        _nc.addObserver(forName: BookCoverImageDidDownload, object: _book, queue: nil) { (n: Notification) in
            self.syncWithBook()
        }
        syncWithBook()

        
    }
    
    func stopObserving(){
        
        if let observer = _bookObserver{
            _nc.removeObserver(observer)
            _bookObserver = nil
            _book = nil
        }
        
    }
    
    //MARK: - Lifecycle
    
    // Sets the view in a neutral state, before being reused
    override func prepareForReuse() {
        stopObserving()
        syncWithBook()
    }
    
    deinit {
        stopObserving()
    }
    
    //MARK: - Utils
    private
    func syncWithBook(){
        
        UIView.transition(with: self.coverView,
                          duration: 0.7,
                          options: [.transitionCrossDissolve],
                          animations: { 
                            self.coverView.image =  UIImage(data: (self._book?._image.data)!)
            }, completion: nil)
        
        
        titleView.text = _book?.title
        authorsView.text = _book?.formattedListOfAuthors()
        tagsView.text = _book?.formattedListOfTags()
        
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
    
}
