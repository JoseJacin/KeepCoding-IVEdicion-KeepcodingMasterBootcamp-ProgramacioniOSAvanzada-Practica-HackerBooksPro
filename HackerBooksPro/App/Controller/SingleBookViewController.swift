//
//  SingleBookViewController.swift
//  HackerBooksPro
//
//  Created by Jose Sanchez Rodriguez on 27/02/2017.
//  Copyright © 2017 Jose Sanchez Rodriguez. All rights reserved.
//

import UIKit
import CoreData

class SingleBookViewController: UIViewController {
    
    @IBOutlet weak var favButton: UIBarButtonItem!
    @IBOutlet weak var imageView: UIImageView!
    
    var book: Book? = nil
    var context: NSManagedObjectContext?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = book?.title
        reloadView()
        
        imageView.image = UIImage(named: constants.defaultBookCover)
        
        if let b = book {
            if let cover = b.cover {
                loadCover(cover: cover.binary as! Data)
            }else{
                DataInteractor(manager: DownloadAsyncGCD()).cover(book: b, completion: { (data: Data) in
                    let cover = Cover.get(book: b, binary: data as NSData, context: self.context!)
                    self.loadCover(cover: cover.binary as! Data)
                })
            }
        }
    }
    
    func loadCover(cover: Data){
        self.imageView.image = UIImage(data: cover)
    }
    
    func reloadView(){
        favButton.title = "☆"
        if let book = book {
            if(book.isFavorite){
                favButton.title = "★"
            }else{
                favButton.title = "☆"
            }
        }
    }
    
    func reloadAndNotify(){
        reloadView()
        notifyListDidChanged()
        saveContext(context: context!, process: true)
    }

    @IBAction func favButtonClicket(_ sender: Any) {
        self.book = Book.setIsFavorite(book: book!, context: self.context!)
        reloadAndNotify()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "ShowPDF" {
                let vc = segue.destination as! PDFViewController
                vc.book = self.book
                vc.context = self.context
                
                Book.setLastOpened(book: book!, context: self.context!)
                
                reloadAndNotify()
            }
        }
    }

    func notifyListDidChanged(){
        let nc = NotificationCenter.default
        let notif = NSNotification(name: NSNotification.Name(rawValue: constants.collectionViewChanged), object: nil)
        nc.post(notif as Notification)
    }
}
