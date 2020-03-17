//
//  LocationProvider.swift
//  WeatherApp
//
//  Created by Vinicius Moreira Leal on 15/03/2020.
//  Copyright © 2020 Vinicius Moreira Leal. All rights reserved.
//

import Foundation
import CoreLocation

protocol LocationProvider {
    var isAuthorized: Bool { get }
    var locationProviderDelegate: LocationProviderDelegate? { get set }
    var desiredAccuracy: CLLocationAccuracy { get set }
    func requestWhenInUseAuthorization()
    func requestLocation()
}

protocol LocationProviderDelegate: class {
    func locationManager(_ manager: LocationProvider, didUpdateLocations locations: [CLLocation])
    func locationManager(_ manager: LocationProvider, didFailWithError error: Error)
}

extension CLLocationManager: LocationProvider {
    
    var isAuthorized: Bool {
        return CLLocationManager.authorizationStatus() == .authorizedWhenInUse
    }

    var locationProviderDelegate: LocationProviderDelegate? {
        get { return delegate as! LocationProviderDelegate? }
        set { delegate = newValue as! CLLocationManagerDelegate? }
    }
}
