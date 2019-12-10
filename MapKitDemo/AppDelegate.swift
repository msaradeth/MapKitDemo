//
//  AppDelegate.swift
//  MapKitDemo
//
//  Created by Mike Saradeth on 12/1/19.
//  Copyright © 2019 Mike Saradeth. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    lazy var locationService: LocationService = {
        return LocationService()
    }()


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        locationService.locationManager.startUpdatingLocation()
        
        let viewModel = MapViewModel(items: [], searchStoreService: SearchStoreService(), locationService: locationService)
        let mapViewController = MapViewController.initFromStoryboard(viewModel: viewModel)
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.rootViewController = UINavigationController(rootViewController: mapViewController)
        
        return true
    }
}

