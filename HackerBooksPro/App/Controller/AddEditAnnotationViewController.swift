//
//  AddEditAnnotationViewController.swift
//  HackerBooksPro
//
//  Created by Jose Sanchez Rodriguez on 02/03/2017.
//  Copyright © 2017 Jose Sanchez Rodriguez. All rights reserved.
//

import UIKit
import Foundation
import CoreData
import CoreLocation

class AddEditAnnotationViewController: UIViewController {
    
    @IBOutlet weak var titleText: UITextField!
    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var annotationImage: UIImageView!
    @IBOutlet weak var latitudeText: UILabel!
    @IBOutlet weak var longitudeText: UILabel!
    @IBOutlet weak var directionText: UILabel!
    @IBOutlet weak var dateCreation: UILabel!
    @IBOutlet weak var dateModify: UILabel!
    @IBOutlet weak var camera: UIBarButtonItem!
    
    var annotation: Annotation? = nil
    var book: Book!
    
    
    var locationEnabled = false
    var timer: Timer?    
    let locManager = CLLocationManager()
    var loc: CLLocation?
    var coor: CLLocationCoordinate2D?
    var locationError: NSError?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Radious Border to Description Note
        let borderColor : UIColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0)
        descriptionText.layer.borderWidth = 0.5
        descriptionText.layer.borderColor = borderColor.cgColor
        descriptionText.layer.cornerRadius = 5.0
        
        // Radious Border to Photo Note
        annotationImage.layer.borderWidth = 0.5
        annotationImage.layer.borderColor = borderColor.cgColor
        annotationImage.layer.cornerRadius = 5.0

        if let editAnnotation = annotation {
            titleText.text = editAnnotation.title
            descriptionText.text = editAnnotation.text
            dateCreation.text = formatDate(editAnnotation.creationDate as! Date)
            dateModify.text = formatDate(editAnnotation.modifiedDate as! Date)
            
            if let image = editAnnotation.photo?.binary {
                annotationImage.image = UIImage(data:image as Data,scale:1.0)
            }
        }else{
            self.annotationImage.image = UIImage(named: constants.defaultAnnotationImage+"."+constants.pngExtension)
            dateCreation.text = formatDate(Date())
            dateModify.text = formatDate(Date())
        }
        
        self.titleText.delegate = self
        self.descriptionText.delegate = self
        
        if(UIImagePickerController.isSourceTypeAvailable(.camera) == false) {
              camera.tintColor = UIColor.gray
        }
        
        handleLocation()
    }
    
    @IBAction func saveClicked(_ sender: Any) {
        guard let context = book?.managedObjectContext else { return }
        
        annotation = Annotation.get(id: annotation?.objectID, book: book, context: context)
        annotation?.title = titleText.text!
        annotation?.text = descriptionText.text
        annotation?.modifiedDate = NSDate()
        
        // Location
        if(locationEnabled){
            if let coor = loc?.coordinate{
                let l = Location.init(annotation: annotation!, lat: coor.latitude, lng: coor.longitude, address: directionText.text, context: context)
                l.lat = coor.latitude
                l.long = coor.longitude
                l.address = directionText.text
            }
        }
        
        // Annotation Photo
        if let img = annotationImage.image {
            let data = UIImagePNGRepresentation(img) as NSData?
            let _ = Photo.init(annotation: annotation!, binary: data, context: context)
        }
        
        saveContext(context: context, process: true)
        
        let _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cameraClicked(_ sender: Any) {
        if(UIImagePickerController.isSourceTypeAvailable(.camera)){
            loadCamera()
        }
    }
    
    @IBAction func galleryClicked(_ sender: Any) {
        loadLibrary()
    }
    
    @IBAction func shareClicked(_ sender: Any) {
        loadFacebookShare()
    }
}
