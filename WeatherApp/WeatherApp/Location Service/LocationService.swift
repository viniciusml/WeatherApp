//
//  LocationService.swift
//  WeatherApp
//
//  Created by Vinicius Moreira Leal on 15/03/2020.
//  Copyright © 2020 Vinicius Moreira Leal. All rights reserved.
//

import Foundation
import CoreLocation

public typealias Coordinate = CLLocationCoordinate2D

extension CLLocation: UserLocation {}

public class LocationService: NSObject {
        
    var manager: CLLocationManager
    public var currentLocation: ((LocationResult) -> Void)?
    
    public init(manager: CLLocationManager) {
        self.manager = manager
        super.init()
        self.manager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        self.manager.delegate = self
    }
    
    public func getCurrentLocation() {
        if manager.needsAuthorizationRequest() {
            manager.requestWhenInUseAuthorization()
        } else {
            manager.requestLocation()
        }
    }
}

extension LocationService: CLLocationManagerDelegate {
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            manager.requestLocation()
        }
    }

    public func locationManager(_ manager: CLLocationManager, didCompleteWith locations: [UserLocation]) {
        if let location = locations.last {
            currentLocation?(.success(location))
        } else {
            currentLocation?(.failure(.cannotBeLocated))
        }
    }

    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let receivedLocations = locations.compactMap { $0 as UserLocation }
        locationManager(manager, didCompleteWith: receivedLocations)
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        currentLocation?(.failure(.cannotBeLocated))
    }
}

extension CLLocationManager {
    @objc open func needsAuthorizationRequest() -> Bool {
        CLLocationManager.authorizationStatus() == .notDetermined
    }
}
