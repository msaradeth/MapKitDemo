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
    
    weak var delegate: MapViweVCDelegate?
    private var annotation: MKAnnotation?
    
    func configure(annotation: MKAnnotation, delegate: MapViweVCDelegate) {
        guard let annotation = annotation as? StoreAnnotation else { return }
        self.annotation = annotation
        self.delegate = delegate
        let store = annotation.store
        imageView.image = #imageLiteral(resourceName: "more")
        storeNumber.text = "Store #\(annotation.indexPath.row)"
        if annotation.indexPath.row == 16 {
            storeNumber.isHidden = true
        }
        storeName.text = store.name
        storeAddress.text = "\(store.location.displayAddress[0])\n\(store.location.displayAddress[1])"
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTap))
        addGestureRecognizer(tapGesture)
        
        
    }
    
    @objc func onTap() {
        delegate?.mapView.deselectAnnotation(annotation, animated: true)
    }
    
    @IBAction func handleButtonSelected(_ sender: Any) {
        delegate?.mapView.deselectAnnotation(annotation, animated: true)
    }
}
