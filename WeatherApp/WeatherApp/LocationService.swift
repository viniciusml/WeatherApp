//
//  LocationService.swift
//  WeatherApp
//
//  Created by Vinicius Moreira Leal on 15/03/2020.
//  Copyright © 2020 Vinicius Moreira Leal. All rights reserved.
//

import Foundation

enum LocationError: Error {
    case cannotBeLocated
}

class LocationService {
    
    let provider: LocationProvider
    
    init(provider: LocationProvider) {
        self.provider = provider
    }
    
    func getCurrentLocation(completion: (LocationError) -> Void) {
        if !provider.isAuthorized {
            provider.requestWhenInUseAuthorization()
            completion(.cannotBeLocated)
        } else {
            provider.requestLocation()
        }
    }
}
