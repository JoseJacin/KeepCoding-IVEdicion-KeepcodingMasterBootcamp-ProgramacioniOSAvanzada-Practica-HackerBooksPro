//
//  AnnotationsViewController+Utils.swift
//  HackerBooksPro
//
//  Created by Jose Sanchez Rodriguez on 01/03/2017.
//  Copyright © 2017 Jose Sanchez Rodriguez. All rights reserved.
//

import Foundation
import UIKit
import CoreData

extension AnnotationsViewController:  UICollectionViewDelegate, UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionInfo = self.fetchedResultsController?.sections![section]
        return sectionInfo!.numberOfObjects
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: constants.annotationCell, for: indexPath) as? AnnotationCollectionViewCell
        
        cell?.annotation = (self.fetchedResultsController?.object(at: indexPath))!
        cell?.context = self.context
        
        return cell!
    }    
}
