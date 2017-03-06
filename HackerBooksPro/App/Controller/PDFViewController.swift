//
//  PDFViewController.swift
//  HackerBooksPro
//
//  Created by Jose Sanchez Rodriguez on 27/02/2017.
//  Copyright © 2017 Jose Sanchez Rodriguez. All rights reserved.
//

import UIKit
import CoreData

class PDFViewController: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var webView: UIWebView!
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var notesbutton: UIBarButtonItem!
    @IBOutlet weak var mapButton: UIBarButtonItem!
    @IBOutlet weak var pages: UIBarButtonItem!
    
    var context: NSManagedObjectContext? = nil    
    var book: Book?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = book?.title
        
        activityIndicator.startAnimating()

        disableButtons()
        
        if let b = book {
            if let pdf = b.pdf {
                loadPdf(pdf: pdf.binary as! Data, urlString: b.pdfUrl!)
            }else{
                DataInteractor().pdf(book: b, completion: { (data: Data) in
                    let pdf = Pdf.get(book: b, binary: data as NSData, context: self.context!)
                    self.book?.pdf = pdf
                    self.loadPdf(pdf: pdf.binary as! Data, urlString: b.pdfUrl!)
       
                })
            }
        }
    }
    
    func loadPdf(pdf: Data, urlString: String){
        if let url = URL.init(string: urlString){
            self.webView.load(pdf, mimeType: "application/pdf", textEncodingName: "", baseURL: url.deletingLastPathComponent())
            self.activityIndicator.stopAnimating()
        }
        enableButtons()
    }
    
    func enableButtons(){
        addButton.isEnabled = true
        notesbutton.isEnabled = true
        mapButton.isEnabled = true
    }
    
    func disableButtons(){
        addButton.isEnabled = false
        notesbutton.isEnabled = false
        mapButton.isEnabled = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
                    case "ShowNotes":
                    let vc = segue.destination as! AnnotationsViewController
                    vc.context = self.context
                    vc.book = book!
                    vc.fetchedResultsController = Annotation.fetchController(book: book!, context: self.context!)
                    break
                case "AddNote":
                    let vc = segue.destination as! AddEditAnnotationViewController
                    vc.book = book!
                    break
                case "ShowMap":
                    let vc = segue.destination as! MapViewController
                    vc.book = book!
                    vc.fetchedResultsController = Annotation.fetchController(book: book!, context: self.context!)
                    break
                default:
                    break
            }
        }
    }
}
