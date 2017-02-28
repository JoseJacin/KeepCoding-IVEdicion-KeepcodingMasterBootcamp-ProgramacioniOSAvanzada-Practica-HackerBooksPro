//
//  BookViewController.swift
//  HackerBooksLite
//
//  Created by Fernando Rodríguez Romero on 8/21/16.
//  Copyright © 2016 KeepCoding. All rights reserved.
//

import UIKit

class BookViewController: UIViewController {

    //MARK: - Init
    var _model : Book
    
    init(model: Book){
        _model = model
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Outlets
    @IBOutlet weak var coverView: UIImageView!
    @IBOutlet weak var favoriteItem: UIBarButtonItem!
    
    //MARK: - Actions
    @IBAction func readBook(_ sender: AnyObject) {
        
        let pVC = PDFViewController(model: _model)
        navigationController?.pushViewController(pVC, animated: true)
        
    }
    
    @IBAction func switchFavorite(_ sender: AnyObject) {
        _model.isFavorite = !_model.isFavorite
        
    }
    //MARK: - Syncing
    func syncViewWithModel(book: Book){
        
        coverView.image = UIImage(data: _model._image.data)
        title = _model.title
        if _model.isFavorite{
            favoriteItem.title = "★"
        }else{
            favoriteItem.title = "☆"
        }
        title = _model.title
        
    }
    
    //MARK: - LifeCycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startObserving(book: _model)
        syncViewWithModel(book: _model)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopObserving(book: _model)
    }
    
    
    //MARK: - Notifications
    let _nc = NotificationCenter.default
    var bookObserver : NSObjectProtocol?
    
    func startObserving(book: Book){
        bookObserver = _nc.addObserver(forName: BookDidChange, object: book, queue: nil){ (n: Notification) in
            self.syncViewWithModel(book: book)
        }
    }
    
    func stopObserving(book:Book){
        guard let observer = bookObserver else{
            return
        }
        _nc.removeObserver(observer)
    }
    
}

extension BookViewController: LibraryViewControllerDelegate{
    
    func libraryViewController(_ sender: LibraryViewController,
                               didSelect selectedBook:Book){
        stopObserving(book: _model)
        _model = selectedBook
        startObserving(book: selectedBook)
        
    }
}


