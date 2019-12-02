//
//  PinMapViewController.swift
//  MapKitDemo
//
//  Created by Mike Saradeth on 12/1/19.
//  Copyright © 2019 Mike Saradeth. All rights reserved.
//

import UIKit
import MapKit
import RxSwift

class PinMapViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet weak var mapView: MKMapView!
    let disposeBag = DisposeBag()
    var locationService: LocationService {
        return (UIApplication.shared.delegate as! AppDelegate).locationService
    }
    lazy var viewModel: MapViewModel = {
        return MapViewModel(items: [],
                            searchStoreService: SearchStoreService(),
                            locationService: locationService)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMapView()
        locationService.subject.take(1).subscribe(onNext: { [weak self] (coordinate) in
            self?.viewModel.searchStore(location: "Restaurant", coordinate: coordinate) { [weak self] in
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.mapView.addAnnotations(self.viewModel.annotations)
                    //                    self.mapView.showAnnotations(self.viewModel.annotations, animated: true)
                    let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
                    self.mapView.setRegion(region, animated: true)
                }
            }
        }).disposed(by: disposeBag)
    }
    
    private func setupMapView() {
        mapView.delegate = self
//        mapView.register(PinAnnotation.self, forAnnotationViewWithReuseIdentifier: PinAnnotation.reuseIdentifier)
//        mapView.register(CustomBusinessCallOut.self, forAnnotationViewWithReuseIdentifier: CustomBusinessCallOut.reuseIdentifier)
    }
    

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        if annotation is PinAnnotation {
            let reuseId = "Pin"
            var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
            if pinView == nil {
                pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            }
            else {
                pinView?.annotation = annotation
            }
            
            return pinView
        } else if annotation is CustomBusinessCallOut {
            let reuseId = "Callout"
            var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
            if pinView == nil {
                pinView = CalloutAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
                pinView?.addSubview(UIImageView(image: UIImage(named: "car")))
            }
            else {
                pinView?.annotation = annotation
            }
            
            return pinView
        } else {
            return nil
        }
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard view.annotation is PinAnnotation else { return }
        if let pinAnnotation = view.annotation as? PinAnnotation {
            let calloutAnnotation = CustomBusinessCallOut(location: pinAnnotation.coordinate)
            calloutAnnotation.title = pinAnnotation.title
            pinAnnotation.calloutAnnotation = calloutAnnotation
            mapView.addAnnotation(calloutAnnotation)
        }
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        guard view.annotation is PinAnnotation else { return }
        if let pinAnnotation = view.annotation as? PinAnnotation,
            let calloutAnnotation = pinAnnotation.calloutAnnotation {
            mapView.removeAnnotation(calloutAnnotation)
            pinAnnotation.calloutAnnotation = nil
        }
    }
}
