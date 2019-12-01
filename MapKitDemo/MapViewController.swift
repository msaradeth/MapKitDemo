//
//  MapViewController.swift
//  MapKitDemo
//
//  Created by Mike Saradeth on 12/1/19.
//  Copyright © 2019 Mike Saradeth. All rights reserved.
//

import UIKit
import MapKit
import RxSwift

class MapViewController: UIViewController {
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
                    self.mapView.showAnnotations(self.viewModel.annotations, animated: true)
                    let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
                    self.mapView.setRegion(region, animated: true)
                }
            }
        }).disposed(by: disposeBag)
    }
    
    private func setupMapView() {
        mapView.delegate = self
        mapView.register(StoreAnnotationView.self, forAnnotationViewWithReuseIdentifier: StoreAnnotationView.reuseIdentifier)
    }
}

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: StoreAnnotationView.reuseIdentifier, for: annotation) as? StoreAnnotationView else {
            return StoreAnnotationView(annotation: annotation, reuseIdentifier: StoreAnnotationView.reuseIdentifier)
        }
        annotationView.configure(annotation: annotation)
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let storeCalloutView = Bundle.main.loadNibNamed("StoreCalloutView", owner: self, options: nil)?.first as? StoreCalloutView else { return }
        view.addSubview(storeCalloutView)
        storeCalloutView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        storeCalloutView.configure(annotationView: view)

        //Addjust size to fit storeCalloutView autolayout
        let size = storeCalloutView.systemLayoutSizeFitting(CGSize(width: 100, height: UIView.layoutFittingCompressedSize.height), withHorizontalFittingPriority: UILayoutPriority.required, verticalFittingPriority: UILayoutPriority.fittingSizeLevel)
        view.bounds = CGRect(x: size.width/2, y: size.height*2, width: size.width, height: size.height)
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        view.subviews.filter { $0 is StoreCalloutView}.forEach { (calloutView) in
            calloutView.removeFromSuperview()
        }
        view.bounds = CGRect(origin: .zero, size: CGSize(width: 60, height: 60))
    }
}
