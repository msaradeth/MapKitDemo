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
//                    self.mapView.showAnnotations(self.viewModel.annotations, animated: true)
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
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: StoreAnnotationView.reuseIdentifier, for: annotation) as? StoreAnnotationView
        if annotationView == nil {
            annotationView = StoreAnnotationView(annotation: annotation, reuseIdentifier: StoreAnnotationView.reuseIdentifier)
        }
        annotationView?.configure(annotation: annotation, vc: self)
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("didSelect")
    }

    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        print("didDeselect")
    }
}
