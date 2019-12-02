//
//  StoreAnnotationView.swift
//  FastFood
//
//  Created by Mike Saradeth on 7/25/19.
//  Copyright © 2019 Mike Saradeth. All rights reserved.
//

import Foundation
import MapKit

class StoreAnnotationView: MKAnnotationView {
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        configure(annotation: annotation)
    }

    //Required for MKAnnotationView
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configure(annotation: MKAnnotation?) {
        guard let annotation = annotation as? StoreAnnotation else { return }
        self.annotation = annotation
        self.image = #imageLiteral(resourceName: "selectedLocation")
        self.canShowCallout = true
        
        //Add detail callout view
        guard let calloutView = Bundle.main.loadNibNamed("StoreCalloutView", owner: self, options: nil)?.first as? StoreCalloutView else {
            return
        }
        calloutView.configure(annotation: annotation)
        detailCalloutAccessoryView = calloutView
    }
    
//    override func prepareForReuse() {
//        super.prepareForReuse()
//        self.subviews.filter { $0 is StoreCalloutView}.forEach { (calloutView) in
//            calloutView.removeFromSuperview()
//        }
//    }

}

extension StoreAnnotationView {
    static let reuseIdentifier = String(describing: self)
}
