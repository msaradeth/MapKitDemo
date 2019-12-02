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

    func configure(annotation: MKAnnotation) {
        guard let annotation = annotation as? StoreAnnotation else { return }
        
        let store = annotation.store
        imageView.image = #imageLiteral(resourceName: "more")
        storeNumber.text = "Store #\(annotation.indexPath.row)"
        storeName.text = store.name
        storeAddress.text = "\(store.location.displayAddress[0])\n\(store.location.displayAddress[1])"
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTap))
        addGestureRecognizer(tapGesture)
    }
    
    @objc func onTap() {
        print("deselectAnnotation")
//        mapView?.deselectAnnotation(annotation, animated: true)
    }
}
