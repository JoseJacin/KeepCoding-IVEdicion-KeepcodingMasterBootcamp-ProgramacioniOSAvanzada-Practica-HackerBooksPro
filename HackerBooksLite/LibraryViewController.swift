//
//  LibraryViewController.swift
//  HackerBooksLite
//
//  Created by Fernando Rodríguez Romero on 8/17/16.
//  Copyright © 2016 KeepCoding. All rights reserved.
//

import UIKit

class LibraryViewController: UITableViewController {

    private
    let _model : Library
    
    
    var delegate : LibraryViewControllerDelegate?
    
    
    //MARK: - Init & Lifecycle
    init(model: Library, style : UITableViewStyle = .plain) {
        _model = model
        super.init(nibName: nil, bundle: nil)   // default options
        title = "HackerBooks"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerNib()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNotifications()
    }
    
    deinit {
        tearDownNotifications()
    }
    

    // Hack: this shouldn't be necessary
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Cell registration
    private func registerNib(){
        
        let nib = UINib(nibName: "BookTableViewCell", bundle: Bundle.main)
        tableView.register(nib, forCellReuseIdentifier: BookTableViewCell.cellID)
    }
    
    //MARK: - Data Source
    override
    func numberOfSections(in tableView: UITableView) -> Int {
        return _model.tags.count
    }
    
    override
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return _model.tags[section]._name
    }
    
    override
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let tagName = _model.tags[section]._name
        
        guard let books = _model.books(forTagName: tagName) else {
            fatalError("No books for tag: \(tagName)")
        }
        
        return books.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        // Find the book
        let tag = _model.tags[indexPath.section]
        let book = _model.book(forTagName: tag._name, at: indexPath.row)!
        
        
        // Create the cell
        let cell = tableView.dequeueReusableCell(withIdentifier: BookTableViewCell.cellID, for: indexPath) as! BookTableViewCell
        
        
        // Sync model (book) -> View (cell)
        cell.startObserving(book: book)
        
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return BookTableViewCell.cellHeight
    }
    
    
    //MARK: - Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Get the book
        let tag = _model.tags[indexPath.section]
        let book = _model.book(forTagName: tag._name, at: indexPath.row)!
        
        // Create the VC
        let bookVC = BookViewController(model: book)
        
        // Load it
        navigationController?.pushViewController(bookVC, animated: true)
        
        
        
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // The cell was just hidden: stop observing
        let cell = tableView.cellForRow(at: indexPath) as! BookTableViewCell
        cell.stopObserving()
    }
    
    //MARK: - Notifications
    // Observes the notifications that come from Book,
    // and reloads the table
    var bookObserver : NSObjectProtocol?
    
    func setupNotifications() {
        
        let nc = NotificationCenter.default
        bookObserver = nc.addObserver(forName: BookDidChange, object: nil, queue: nil)
        { (n: Notification) in
            self.tableView.reloadData()
        }
    }
    
    func tearDownNotifications(){
        guard let observer = bookObserver else{
            return
        }
        let nc = NotificationCenter.default
        nc.removeObserver(observer)
    }

}



//MARK: - Delegate protocol
protocol LibraryViewControllerDelegate {
    func libraryViewController(_ sender: LibraryViewController, didSelect selectedBook:Book)
}


