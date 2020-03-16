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
    var locationManagerDelegate: CLLocationManagerDelegate? { get set }
    var desiredAccuracy: CLLocationAccuracy { get set }
    func requestWhenInUseAuthorization()
    func requestLocation()
}

extension CLLocationManager: LocationProvider {
    
    var isAuthorized: Bool {
        return CLLocationManager.authorizationStatus() == .authorizedWhenInUse
    }

    var locationManagerDelegate: CLLocationManagerDelegate? {
        get { return delegate }
        set { delegate = newValue }
    }

}
