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

protocol MapViweVCDelegate: NSObjectProtocol {
    var mapView: MKMapView! { get set }
}

class MapViewController: UIViewController, MapViweVCDelegate {
    @IBOutlet weak var mapView: MKMapView!
    let disposeBag = DisposeBag()
    var viewModel: MapViewModel!
    lazy var calloutView: StoreCalloutView = {
        let calloutView = Bundle.main.loadNibNamed("StoreCalloutView", owner: self, options: nil)![0] as! StoreCalloutView
        return calloutView
    }()
    
    class func initFromStoryboard(viewModel: MapViewModel) -> MapViewController {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
        vc.viewModel = viewModel
        return vc
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupMapView()
        viewModel.locationService.subject.take(1).subscribe(onNext: { [weak self] (coordinate) in
            self?.viewModel.searchStore(location: "Restaurant", coordinate: coordinate) { [weak self] in
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.mapView.addAnnotations(self.viewModel.annotations)
                    self.updateUI(coordinate: coordinate)
                }
            }
        }).disposed(by: disposeBag)
    }
    
    private func setupMapView() {
        mapView.delegate = self
        mapView.register(StoreAnnotationView.self, forAnnotationViewWithReuseIdentifier: StoreAnnotationView.reuseIdentifier)
    }
    
    private func updateUI(coordinate: CLLocationCoordinate2D) {
        mapView.showAnnotations(viewModel.annotations, animated: true)
        let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        mapView.setRegion(region, animated: true)
    }
}

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: StoreAnnotationView.reuseIdentifier, for: annotation) as? StoreAnnotationView
        if annotationView == nil {
            annotationView = StoreAnnotationView(annotation: annotation, reuseIdentifier: StoreAnnotationView.reuseIdentifier)
        }
        annotationView?.configure(annotation: annotation)
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation else { return }
        calloutView.configure(annotation: annotation, delegate: self)
        view.detailCalloutAccessoryView = calloutView
    }

    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        print("didDeselect")
    }
}
