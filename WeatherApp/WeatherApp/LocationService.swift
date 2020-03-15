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

protocol UserLocation {
    var coordinate: Coordinate { get }
}

extension CLLocation: UserLocation { }

enum LocationError: Error {
    case cannotBeLocated
}

typealias LocationResult = Result<UserLocation, LocationError>

protocol LocationAdapter {
    func getCurrentLocation(completion: (LocationResult) -> Void)
}

class LocationService: LocationAdapter {
    
    let provider: LocationProvider
    
    init(provider: LocationProvider) {
        self.provider = provider
    }
    
    func getCurrentLocation(completion: (LocationResult) -> Void) {
        if !provider.isAuthorized {
            provider.requestWhenInUseAuthorization()
            completion(.failure(.cannotBeLocated))
        } else {
            provider.requestLocation()
        }
    }
}
