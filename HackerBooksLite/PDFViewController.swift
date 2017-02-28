//
//  PDFViewController.swift
//  HackerBooksLite
//
//  Created by Fernando Rodríguez Romero on 8/24/16.
//  Copyright © 2016 KeepCoding. All rights reserved.
//

import UIKit

class PDFViewController: UIViewController{
    
    var _model : Book?
    var _bookObserver : NSObjectProtocol?
    
    @IBOutlet weak var browserView: UIWebView!

    
    init(model: Book){
        _model = model
        super.init(nibName: nil, bundle: nil)
        title = _model?.title
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNotifications()

        browserView.load((_model?._pdf.data)!, mimeType: "application/pdf", textEncodingName: "utf8", baseURL: URL(string:"http://www.google.com")!)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tearDownNotifications()
    }
    
    
}




//MARK: - Notifications
extension PDFViewController{
    
    func setupNotifications(){
        
        let nc = NotificationCenter.default
        _bookObserver = nc.addObserver(forName: BookPDFDidDownload, object: _model, queue: nil){ (n: Notification) in
            
            self.browserView.load((self._model?._pdf.data)!, mimeType: "application/pdf", textEncodingName: "utf8", baseURL: URL(string:"http://www.google.com")!)


            
        }
    }
    
    func tearDownNotifications(){
        
        guard let observer = _bookObserver else{
            return
        }
        let nc = NotificationCenter.default
        nc.removeObserver(observer)
        _bookObserver = nil
    }
}
