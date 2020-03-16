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

class LocationService: NSObject, LocationAdapter {
        
    var provider: LocationProvider
    private var currentLocation: ((LocationResult) -> Void)?
    
    init(provider: LocationProvider) {
        self.provider = provider
        super.init()
        self.provider.desiredAccuracy = kCLLocationAccuracyHundredMeters
        self.provider.locationManagerDelegate = self
    }
    
    func getCurrentLocation(completion: @escaping (LocationResult) -> Void) {
        self.currentLocation = completion
        if !provider.isAuthorized {
            provider.requestWhenInUseAuthorization()
            completion(.failure(.cannotBeLocated))
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
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            currentLocation?(.success(location))
        } else {
            currentLocation?(.failure(.cannotBeLocated))
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        currentLocation?(.failure(.cannotBeLocated))
    }
}
