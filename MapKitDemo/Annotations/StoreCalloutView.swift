//
//  StoreCalloutView.swift
//  MapKitDemo
//
//  Created by Mike Saradeth on 12/1/19.
//  Copyright © 2019 Mike Saradeth. All rights reserved.
//

import UIKit
import MapKit

class StoreCalloutView: UIView {
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var storeNumber: UILabel!
    @IBOutlet weak var storeName: UILabel!
    @IBOutlet weak var storeAddress: UILabel!
    
    let testText = "Copyright © 2019 Mike Saradeth. All rights reserved."
    func configure(annotationView: MKAnnotationView) {
        imageView.image = annotationView.isSelected ? #imageLiteral(resourceName: "selectedLocation") : #imageLiteral(resourceName: "unSelectedlocation")
        guard let annotation = annotationView.annotation as? StoreAnnotation else { return }
        storeNumber.text = annotation.title
        storeName.text = annotation.store.name
        storeAddress.text = testText  //annotation.store.location.displayAddress.count >= 1 ? "\(annotation.store.location.displayAddress[0])" : ""
    }
    
//    func fillsuperview() {
//        guard let superview = self.superview else { return }
//        leadingAnchor.constraint(equalTo: superview.leadingAnchor).isActive = true
//        trailingAnchor.constraint(equalTo: superview.trailingAnchor).isActive = true
//        topAnchor.constraint(equalTo: superview.topAnchor).isActive = true
//        bottomAnchor.constraint(equalTo: superview.bottomAnchor).isActive = true
//    }
}
