//
//  AddEditAnnotationViewController+Utils.swift
//  HackerBooksPro
//
//  Created by Jose Sanchez Rodriguez on 02/03/2017.
//  Copyright © 2017 Jose Sanchez Rodriguez. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit
import Social

//MARK: - Extensions
//MARK:- Annotation
extension AddEditAnnotationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.titleText.resignFirstResponder()
        self.view.endEditing(true);
        return true;
    }
}

extension AddEditAnnotationViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            self.descriptionText.resignFirstResponder()
            return false
        }
        return true
    }
}

extension AddEditAnnotationViewController: CLLocationManagerDelegate {
    func handleLocation(){
        let authStatus = CLLocationManager.authorizationStatus()
        if authStatus == .notDetermined {
            locManager.requestWhenInUseAuthorization()
        }
        
        if authStatus == .denied || authStatus == .restricted {
            locationDisabledAlert()
            return
        }
        
        startLocation()
    }
    
    func startLocation() {
        if CLLocationManager.locationServicesEnabled() {
            
            locManager.delegate = self
            locManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locManager.startUpdatingLocation()
            locationEnabled = true
            
            timer = Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(AddEditAnnotationViewController.locationTimedOut), userInfo: nil, repeats: false)
        }
    }
    
    func stopLocation() {
        if locationEnabled {
            if let timer = timer {
                timer.invalidate()
            }
            
            locManager.stopUpdatingLocation()
            locManager.delegate = nil
            locationEnabled = false
        }
    }
    
    func locationDisabledAlert() {
        let alert = UIAlertController(title: constants.locationServiceDisabled, message: constants.locationServiceDisabledMessage, preferredStyle: .alert)
        let okAction = UIAlertAction(title: constants.locationServiceDisabledOK, style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    func locationTimedOut() {
        if loc == nil {
            stopLocation()
            let alert = UIAlertController(title: constants.locationServiceTimedOut, message: constants.locationServiceTimedOutMessage, preferredStyle: .alert)
            let okAction = UIAlertAction(title: constants.locationServiceTimedOutOK, style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {        
        if (error as NSError).code == CLError.Code.locationUnknown.rawValue {
            return
        }
        
        locationError = error as NSError?
        stopLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        loc = locations.last!
        
        if let l = loc {
            latitudeText.text = String(format: "%.8f", l.coordinate.latitude)
            longitudeText.text = String(format: "%.8f", l.coordinate.longitude)
        }
                
        CLGeocoder().reverseGeocodeLocation(manager.location!, completionHandler: {(placemarks, error) -> Void in
            if (error != nil) {
                self.directionText.text = "..."
                return
            }
            
            if (placemarks?.count)! > 0 {
                let pm = (placemarks?[0])! as CLPlacemark
                
                let country = pm.country != nil ? pm.country : ""
                let postalCode = pm.postalCode != nil ? pm.postalCode : ""
                let locality = pm.locality != nil ? pm.locality : ""
                
                self.directionText.text = country! + " (" + postalCode! + ") " + locality!
            } else {
                self.directionText.text = "..."
            }
        })
        
        locationError = nil
    }
}

extension AddEditAnnotationViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func loadLibrary(){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        
        imagePicker.modalPresentationStyle = .fullScreen
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    func loadCamera(){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = true
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        annotationImage.image = info[UIImagePickerControllerEditedImage] as? UIImage
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

//MARK:- Social
extension AddEditAnnotationViewController {
    func loadFacebookShare(){
        let facebookVC = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
        if let facebookVC = facebookVC {
            facebookVC.setInitialText(titleText.text)
            if let image = annotationImage.image {
                facebookVC.add(image)
            }
            present(facebookVC, animated: true, completion: nil)
        }
    }
}
