//
//  LocationService.swift
//  WeatherApp
//
//  Created by Vinicius Moreira Leal on 15/03/2020.
//  Copyright © 2020 Vinicius Moreira Leal. All rights reserved.
//

import Foundation
import CoreLocation

typealias Coordinate = CLLocationCoordinate2D

extension CLLocation: UserLocation { }

class LocationService: NSObject {
        
    var provider: CLLocationManager
    var currentLocation: ((LocationResult) -> Void)?
    
    init(provider: CLLocationManager) {
        self.provider = provider
        super.init()
        self.provider.desiredAccuracy = kCLLocationAccuracyHundredMeters
        self.provider.delegate = self
    }
    
    func getCurrentLocation() {
        if provider.needsAuthorizationRequest() {
            provider.requestWhenInUseAuthorization()
        } else {
            provider.requestLocation()
        }
    }
}

extension LocationService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            provider.requestLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didCompleteWith locations: [UserLocation]) {
        if let location = locations.last {
            currentLocation?(.success(location))
        } else {
            currentLocation?(.failure(.cannotBeLocated))
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let receivedLocations = locations.compactMap { $0 as UserLocation }
        locationManager(manager, didCompleteWith: receivedLocations)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        currentLocation?(.failure(.cannotBeLocated))
    }
}

extension CLLocationManager {
    @objc func needsAuthorizationRequest() -> Bool {
        CLLocationManager.authorizationStatus() == .notDetermined
    }
}
